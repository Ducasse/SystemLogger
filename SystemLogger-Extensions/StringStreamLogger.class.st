"
I'm the root of the logger that log formatter strings out of log objects and 
publish the results into stream.

By default I produce my output on Transcript but it can be any stream. 

| logger |
logger := StringStreamLogger new.
LogDispatcher current addLogger: logger.
LogDispatcher current startAllLoggers.



"
Class {
	#name : 'StringStreamLogger',
	#superclass : 'FormattingLogger',
	#instVars : [
		'stream'
	],
	#category : 'SystemLogger-Extensions-StringOutputter',
	#package : 'SystemLogger-Extensions',
	#tag : 'StringOutputter'
}

{ #category : 'accessing' }
StringStreamLogger class >> defaultStream [
	^ Transcript
]

{ #category : 'instance creation' }
StringStreamLogger class >> on: aStream [
	^ self new
		stream: aStream
]

{ #category : 'instance creation' }
StringStreamLogger class >> on: aStream name: aString [
	^ self new
		stream: aStream;
		name: aString
]

{ #category : 'operations' }
StringStreamLogger >> convertLog: aLog [

	^ (formatter formatLog: aLog from: self)
]

{ #category : 'accessing' }
StringStreamLogger >> defaultStream [
	^ self class defaultStream
]

{ #category : 'operations' }
StringStreamLogger >> handleConvertedLog: aLogEntry [
	"redefine handleConvertedLogEntry: superclass flow to be able to inject cr."
	self stream cr.
	self stream << (self convertLog: aLogEntry)
]

{ #category : 'initialize' }
StringStreamLogger >> initialize [
	super initialize.
	formatter := self defaultFormatter.
	name := 'stream logger'
]

{ #category : 'operations' }
StringStreamLogger >> storeObject: aLog [
	"redefine storeObject: superclass flow to be able to inject cr."
	self stream cr.
	self stream << (self convertLog: aLog)
]

{ #category : 'accessing' }
StringStreamLogger >> stream [
	^ stream ifNil: [ 
		stream := self defaultStream  ]
]

{ #category : 'accessing' }
StringStreamLogger >> stream: anObject [
	stream := anObject
]
