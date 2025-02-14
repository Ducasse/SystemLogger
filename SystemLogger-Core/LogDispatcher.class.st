"
This class is kind of private from the access view point. It is the main log objects dispatcher.  You can access it using the expression Log dispatcher. 


The core of SystemLogger is composed of three kind of objects: log objects, loggers and log dispatchers.  

When a log object is created, it is passed to the system log dispatcher. There is only one logDispatcher in the system, it is an instance of ==LogDispatcher== and can be accessed ==LogDispatcher current==. His role is to dispatch the emitted log objects to the system loggers that registered to the dispatcher. 

There is one favorite system logger associated to the current dispatcher. It is the main default logger. It can be accessed by the following expression: ==self current defaultLogger==. 

In addition, we can add loggers to the current dispatcher using ==addLogger:==. A dispatcher will dispatch log to any available loggers. 

[[[
	Log dispatcher addLogger: (MySpecialLogger name: 'test1').
]]]

Similarly you can remove a system logger using the ==removeLogger:== or ==removeLoggerNamed:== messages.
	
Finally all loggers can be stopped to receive log objects from the log dispatcher and started using the messages 
==startAllLoggers== and ==stopAllLoggers==. 
"
Class {
	#name : 'LogDispatcher',
	#superclass : 'Object',
	#instVars : [
		'mutex',
		'loggers'
	],
	#classInstVars : [
		'current'
	],
	#category : 'SystemLogger-Core',
	#package : 'SystemLogger-Core'
}

{ #category : 'managing system loggers' }
LogDispatcher class >> addLogger: aLogger [
	
	self current addLogger: aLogger
]

{ #category : 'accessing' }
LogDispatcher class >> current [
	current isNil ifTrue: [ current := self new ].
	^current
			
]

{ #category : 'accessing' }
LogDispatcher class >> defaultLogger [
	^ self current defaultLogger
]

{ #category : 'initialization' }
LogDispatcher class >> initialize [
	"self initialize"
	
	self current startAllLoggers.
]

{ #category : 'managing system loggers' }
LogDispatcher class >> removeLogger: aLogger [
	self current removeLogger: aLogger
]

{ #category : 'managing system loggers' }
LogDispatcher class >> removeLoggerNamed: aString [
	
	^ self current removeLoggerNamed: aString
]

{ #category : 'initialize' }
LogDispatcher class >> reset [
	"self reset"
	current ifNotNilDo: [ :cu |  cu loggers do: [ :each | each reset ]].
	current := nil.
	
			
]

{ #category : 'initialize' }
LogDispatcher >> addDefaultLogger [

	self loggers add: SystemLogger defaultLogger.

]

{ #category : 'passing logs' }
LogDispatcher >> addLog: aLogObject [
	"Pass the argument to all the loggers currently registered."
	
	"mutex critical: ["
		self loggers do: [ :logger | logger addLog: aLogObject ]
	"].".
	^aLogObject
]

{ #category : 'loggers' }
LogDispatcher >> addLogger: aLogger [
	"Add a new logger to the list of the current ones. Loggers are identified by their names."
	
	self loggers add: aLogger
			
]

{ #category : 'initialize' }
LogDispatcher >> defaultLogger [

	^ self loggerNamed: 'default'
]

{ #category : 'initialization' }
LogDispatcher >> initialize [
	super initialize.
	self initializeLoggers.
	mutex := Semaphore forMutualExclusion.
	self addDefaultLogger
]

{ #category : 'initialization' }
LogDispatcher >> initializeLoggers [

	loggers := Set new
]

{ #category : 'accessing' }
LogDispatcher >> loggerNamed: aString [
	"Return a logger named aString"

	^ loggers 
		detect: [ :logger | logger name = aString ] 
		ifNone: [ nil ]
			
]

{ #category : 'accessing' }
LogDispatcher >> loggers [
	^ loggers
			
]

{ #category : 'loggers' }
LogDispatcher >> removeAllLoggers [

	loggers do: [ :each | each reset ].
	self initializeLoggers. 
]

{ #category : 'loggers' }
LogDispatcher >> removeLogger: aLogger [
	
	^ self loggers 
		remove: aLogger
		ifAbsent: [ nil ]
]

{ #category : 'loggers' }
LogDispatcher >> removeLoggerNamed: aString [
	"removes the first logger found with that name"
	
	^ self removeLogger: (self loggerNamed: aString)
]

{ #category : 'resetting' }
LogDispatcher >> reset [
	self removeAllLoggers.
	self addDefaultLogger 
]

{ #category : 'logging' }
LogDispatcher >> startAllLoggers [
	
	"mutex critical: [" 
			self loggers do: [ :logger | logger startLogging]
			"]"
]

{ #category : 'logging' }
LogDispatcher >> stopAllLoggers [

	"mutex critical: ["
		self loggers do: [ :logger | logger stopLogging]"]"
]
