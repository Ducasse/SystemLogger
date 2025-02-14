Class {
	#name : 'LogTest',
	#superclass : 'TestCase',
	#instVars : [
		'log'
	],
	#category : 'SystemLogger-Tests',
	#package : 'SystemLogger-Tests'
}

{ #category : 'running' }
LogTest >> setUp [
	LogDispatcher reset
			
]

{ #category : 'running' }
LogTest >> testCreatedLogExtensionCanBePassedAsArray [
	"an extension is a key/value pair so that users of Log can put in the log the information they need."
	"self debug: #testLogExtensionCanBePassedAsArray"
	| str |
	str := 'Test message'.
	log := str asLog
				tag: 'Inside testLog method' ; 
				info ;
				addExtensions: {#context -> thisContext . #what -> 'current stack'}.
	self 
		assert: log message = str;
		assert: log level = LogLevel info;
		assert: (log extensionAt: #context) class equals: Context; 
		assert: (log extensionAt: #what) = 'current stack'.
]

{ #category : 'running' }
LogTest >> testCreatedLogExtensionCanBePassedAsAtPutProtocol [
	"an extension is a key/value pair so that users of Log can put in the log the information they need."
	"self debug: #testLogExtensionCanBePassedAsAtPutProtocol"
	
	| str |
	str := 'Test message'.
	log := str asLog
				tag: 'Inside testLog method' ; 
				info ;
				extensionAt: #context put: thisContext; 
				yourself.
	self 
		assert: log message = str;
		assert: log level = LogLevel info;
		assert: (log extensionAt: #context) class equals: Context
	
				
]

{ #category : 'running' }
LogTest >> testCreatedLogShouldHandleTagInfoAndMessage [

	| str |
	str := 'Test message'.
	log := str asLog
			tag: 'Inside testLog method' ; 
			info.
	self 
		assert: log message = str;
		assert: log level = LogLevel info;
		assert: log tag =  'Inside testLog method'.
	
				
]

{ #category : 'running' }
LogTest >> testQueryingUnexistingExtensionShouldEvaluateIfAbsentBlock [
	"self debug: #testQueryingUnexistingExtensionShouldEvaluateIfAbsentBlock"

	| str |
	str := 'Test message'.
	log := Log new
				tag: 'Inside testLog method' ; 
				info ;
				message: str; 
				addExtensions: {#context -> thisContext . #what -> 'current stack'}.
	self assert: (log extensionAt: #whaaaaat ifAbsent: ['absent']) = 'absent'.
]
