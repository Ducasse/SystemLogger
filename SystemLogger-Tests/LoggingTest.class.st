Class {
	#name : 'LoggingTest',
	#superclass : 'TestCase',
	#category : 'SystemLogger-Tests',
	#package : 'SystemLogger-Tests'
}

{ #category : 'as yet unclassified' }
LoggingTest >> setUp [ 
	Log dispatcher reset.
	Log dispatcher startAllLoggers.
	
]

{ #category : 'tests' }
LoggingTest >> testCustomLogObjectWithCustomLogMessage [
	"self debug: #testCustomLogObjectWithCustomLogMessage"

	"TestLogObject (derived from BasicLog) shall be logged as message 
	of a custom log object. It overrides logClass on the class side"
	
	(TestLogObject new foo: 'bar15') asLog emit.
	self assert: Logger default logs size = 2.
	self assert: Logger default logs second class = CustomTestLog.
	self assert: Logger default logs second message foo = 'bar15'
]
