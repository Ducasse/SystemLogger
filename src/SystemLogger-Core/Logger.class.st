"
==Logger== is the abstract superclass of system loggers. It has a name. 

It defined the following messages:

- ==startLogging== and ==stopLogging== enable and respectively disable the handling of log objects.
- ==filter: aBlock== to specify the condition that the log objects should satisfy to be handled by the system logger. 
- ==addLog: aLog== sent by the log dispatcher.
- ==addLogHook: aLog== is a hook message that specifies the effective action performed when handling a log object.
- ==reset== flushes the log objects if any that could have been hold by the receiver.
"
Class {
	#name : 'Logger',
	#superclass : 'Object',
	#instVars : [
		'name',
		'isLogging',
		'filter'
	],
	#category : 'SystemLogger-Core',
	#package : 'SystemLogger-Core'
}

{ #category : 'accessing' }
Logger class >> announcer [

	^ SystemAnnouncer uniqueInstance
]

{ #category : 'accessing' }
Logger class >> default [
	"return the default logger associated to the singleton Log dispatcher, normally this is a systemLogger"
	
	^ LogDispatcher defaultLogger
]

{ #category : 'instance creation' }
Logger class >> name: aString [
	^ self new 
		name: aString
]

{ #category : 'accessing' }
Logger class >> named: aString [
	^ LogDispatcher current loggers
		detect: [ :each| each name = aString ]
		ifNone: [ nil ]
]

{ #category : 'adding/removing' }
Logger >> addLog: aLog [ 
	"Check whether the log is worth logging. If this is the case log it and announce that a new log was logged."
	self isLogging ifFalse: [^self].
	(self interestedIn: aLog) ifFalse: [^self].
	self addLogHook: aLog.
	self announcer announce: (LogAdded new log: aLog)
	
]

{ #category : 'adding/removing' }
Logger >> addLogHook: aLog [ 
	"This method is invoked when the logger is interested into the log. Subclasses should specialize is to perform specific behavior."
	
	self subclassResponsibility 

]

{ #category : 'private' }
Logger >> announcer [
	^ self class announcer
]

{ #category : 'private' }
Logger >> dispatcher [ 
	"Returns the current logging multiplexer, i.e., the object dispatching logs to all the registerer logger."
	^ LogDispatcher current
]

{ #category : 'actions' }
Logger >> emitStartLogging [
	"Since a logger emits its own log entry"

	^ Log message: name asString , ' started to log' tag: 'SystemLogger'
]

{ #category : 'actions' }
Logger >> emitStopLogging [
	"Since a logger emits its own log entry"

	^ Log message: name asString , ' stopped to log' tag: 'SystemLogger'
]

{ #category : 'accessing' }
Logger >> filter: aBlock [

	filter := aBlock
]

{ #category : 'initialization' }
Logger >> initialize [

	super initialize.
	name := 'unamed'.
	filter := [ :event | true ]
]

{ #category : 'testing' }
Logger >> interestedIn: aLog [
	"Return whether the receiver is interested to get the log"
	^ filter value: aLog
]

{ #category : 'testing' }
Logger >> isLogging [
	"Returns whether the receiver is actively logging log objects."
	isLogging isNil ifTrue: [isLogging := false].
	^isLogging
			
]

{ #category : 'accessing' }
Logger >> name [

	^ name
]

{ #category : 'accessing' }
Logger >> name: anObject [
	
	name := anObject
]

{ #category : 'printing' }
Logger >> printOn: aStream [
	
	super printOn: aStream.
	aStream << '(' << name asString << ')'.
]

{ #category : 'adding/removing' }
Logger >> reset [
	"Flush the log objects if any that could have been hold by the receiver."
]

{ #category : 'actions' }
Logger >> startLogging [

	self isLogging ifTrue: [^self].
	isLogging := true.
	self emitStartLogging
			
]

{ #category : 'actions' }
Logger >> stopLogging [

	self isLogging ifFalse: [^self].
	isLogging := false.
	self emitStopLogging
			
]
