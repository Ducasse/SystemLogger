"
Logger that outputs sysLog logs via UDP.



[[[
| logger |
logger := SysLogSender new addHost: 'localhost' port: 514
Log dispatcher addLogger: logger.
Log dispatcher startAllLoggers.
]]]


"
Class {
	#name : 'SysLogSender',
	#superclass : 'FormattingLogger',
	#instVars : [
		'hosts',
		'facility',
		'hostName'
	],
	#category : 'SystemLogger-SysLogSender',
	#package : 'SystemLogger-SysLogSender'
}

{ #category : 'defaults' }
SysLogSender class >> defaultFormatter [
	^ SysLogFormatter new
]

{ #category : 'instance creation' }
SysLogSender class >> localhost [
	^ self new
		addHost: 'localhost'
]

{ #category : 'instance creation' }
SysLogSender class >> localhostOn: aPortNumber [
	^ self new
		addHost: 'localhost'
		port: aPortNumber
]

{ #category : 'configuring' }
SysLogSender >> addHost: aString [
	"Add a host to send to, 514 is default syslog port."

	self addHost: aString port: 514
]

{ #category : 'configuring' }
SysLogSender >> addHost: aString port: aPortNumber [
	"Add a host name with portnumber."

	hosts add: aString -> (aPortNumber ifNil: [514])
]

{ #category : 'accessing' }
SysLogSender >> defaultFormatter [
	^ super defaultFormatter 
		converter: UTF8TextConverter new
]

{ #category : 'accessing' }
SysLogSender >> facility [
	^ facility
]

{ #category : 'accessing' }
SysLogSender >> facility: anInteger [
	"We keep it multiplied with 8 so we don't need to do that every time we emit."

	facility := anInteger * 8
]

{ #category : 'operations' }
SysLogSender >> handleConvertedLog: aString [

	hosts do: [:host | self send: aString to: host key port: host value]
]

{ #category : 'accessing' }
SysLogSender >> hostName [
	"Apparently this is not that easy to find cross platform."

	^hostName ifNil: [
		hostName := self localHostname ]
]

{ #category : 'accessing' }
SysLogSender >> hostName: aHostName [
	"Apparently this is not that easy to find cross platform."

	hostName := aHostName
]

{ #category : 'initialize' }
SysLogSender >> initialize [

	super initialize.
	self facility: 16. "Use 1 (=user level) or 16-23 (=local use local0-7)"
	hosts := OrderedCollection new
]

{ #category : 'accessing' }
SysLogSender >> localHostname [
	"resolve local hostname. If no name is resolvable then we get back the IP address.
	We return either the hostname without domain or the IP address"
	| hostname |
	hostname := NetNameResolver localHostName.
	^ (hostname copyAfterLast: $.) isAllDigits
		ifTrue: [ hostname ]
		ifFalse: [ hostname copyUpTo: $. ]
]

{ #category : 'private' }
SysLogSender >> send: message to: host port: port [
	"Send formatted UDP message to host and port."

	| sock |
	sock := Socket newUDP.
	sock sendData: message toHost: (NetNameResolver addressForName: host)   port: port. 
	sock waitForSendDoneFor: Socket standardTimeout.
	sock close
]
