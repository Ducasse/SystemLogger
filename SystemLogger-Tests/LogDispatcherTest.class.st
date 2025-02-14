Class {
	#name : 'LogDispatcherTest',
	#superclass : 'TestCase',
	#category : 'SystemLogger-Tests',
	#package : 'SystemLogger-Tests'
}

{ #category : 'tests' }
LogDispatcherTest >> testAddAndRemovingLogger [
	
	Log dispatcher removeAllLoggers.
	self assert: Log dispatcher loggers isEmpty.
	Log dispatcher addLogger: (SystemLogger name: 'test1').
	self assert: Log dispatcher loggers size = 1.
	Log dispatcher removeLoggerNamed: 'test1'.
	self assert: Log dispatcher loggers isEmpty.
	
	
	
]

{ #category : 'tests' }
LogDispatcherTest >> testRemovingNonExistentLogger [
	
	self assert: (Log dispatcher removeLogger: nil) isNil.
	self assert: (Log dispatcher removeLoggerNamed: 'notthere') isNil.
	self assert: (LogDispatcher removeLoggerNamed: 'notthere') isNil.
	
]

{ #category : 'tests' }
LogDispatcherTest >> testResettingAddsDefaultLogger [

	Log dispatcher removeAllLoggers.
	Log dispatcher reset.
	self assert: Log dispatcher loggers size = 1.	
	self assert: Log dispatcher loggers anyOne class = SystemLogger
]
