Class {
	#name : 'SystemLoggerTest',
	#superclass : 'TestCase',
	#category : 'SystemLogger-Tests',
	#package : 'SystemLogger-Tests'
}

{ #category : 'tests' }
SystemLoggerTest >> dispatcher [
	^ LogDispatcher current
]

{ #category : 'tests' }
SystemLoggerTest >> resetDispatcher [
	LogDispatcher reset
]

{ #category : 'tests' }
SystemLoggerTest >> setUp [

	self resetDispatcher 
]

{ #category : 'tests' }
SystemLoggerTest >> testDefaultLoggerNameShouldBeNamedDefault [
	"self debug: #testMainLoggerNameShouldBeNamedMain"

	self assert: self dispatcher defaultLogger name = 'default'
]

{ #category : 'tests' }
SystemLoggerTest >> testFiltering [
	LogDispatcher current defaultLogger 
		startLogging;
		filter: [ :log|  log message = 'test1' ].
	
	'test1' asLog emit.
	'test2' asLog emit.
	
	"start logging emits a message as well. So there need to be 2 in there"
	self assert: LogDispatcher current defaultLogger logs size = 2.
]

{ #category : 'tests' }
SystemLoggerTest >> testFilteringByLevel [
	Logger default
		filter: LogLevel warning orMoreSevere;
		startLogging.
		
	'test1' asLog warning emit.
	'test2' asLog emit.
	
	self assert: Logger default logs size = 1.
]

{ #category : 'tests' }
SystemLoggerTest >> testLogCreatedWithOtherAPI [
	"self debug: #testLogCreatedWithOtherAPI"

	self dispatcher startAllLoggers.
	SLDomainObject new logCreationUsingExplicitEmitAPI.
	self assert: self dispatcher defaultLogger lastLog message equals: SLDomainObject messageString.
	
]

{ #category : 'tests' }
SystemLoggerTest >> testLoggersShouldContainDefaultLogger [
	
	self assert: (self dispatcher loggers includes: self dispatcher defaultLogger)
]

{ #category : 'tests' }
SystemLoggerTest >> testStartingAndEmittingALogShouldCreateTwoLogsOneForLogStartingAndOneForLog [
	"self debug: #testStartingAndEmittingALogShouldCreateTwoLogsOneForLogStartingAndOneForLog"

	self dispatcher startAllLoggers.
	SLDomainObject new logCreationUsingAddLogLowLevelAPI.
	self assert: self dispatcher defaultLogger logs size equals: 2.
	self assert: self dispatcher defaultLogger logs first message equals: 'default started to log' 
]

{ #category : 'tests' }
SystemLoggerTest >> testTwoLoggersAreHandlingLog [
	"self debug: #testTwoLoggersAreHandlingLog"

	| logger |
	logger := SystemLogger new name: 'foo'.
	self dispatcher addLogger: logger.
	self assert: self dispatcher loggers size = 2. 
	self dispatcher startAllLoggers.
	
	"We cannot check that all the loggers have the same logs, because a logger emit a start log
	when starting and since one logger is started after the other, the second one cannot see the 
	event of the creation of the first one for example."
	
	SLDomainObject new logCreationUsingAddLogLowLevelAPI.
	self assert: logger lastLog message equals: SLDomainObject messageString.
	self assert: self dispatcher defaultLogger lastLog message equals: SLDomainObject messageString.
]
