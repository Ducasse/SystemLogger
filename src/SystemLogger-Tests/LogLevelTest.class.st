Class {
	#name : 'LogLevelTest',
	#superclass : 'TestCase',
	#category : 'SystemLogger-Tests',
	#package : 'SystemLogger-Tests'
}

{ #category : 'running' }
LogLevelTest >> setUp [ 
	LogLevel reset
]

{ #category : 'running' }
LogLevelTest >> testCacheFill [
	self assert: LogLevel levels isEmpty.
	LogLevel all.
	self assert: LogLevel levels size = 8 
]

{ #category : 'running' }
LogLevelTest >> testCustomCacheFill [
	self assert: LogLevel levels isEmpty.
	CustomTestLogLevel all.
	self assert: CustomTestLogLevel levels size = 9
]

{ #category : 'running' }
LogLevelTest >> testCustomLogLevel [
	self assert: (CustomTestLogLevel allLogLevelSelectors includes: #foo)
]

{ #category : 'running' }
LogLevelTest >> testCustomLogLevelIdentity [
	self assert: (CustomTestLogLevel foo == CustomTestLogLevel foo)
]
