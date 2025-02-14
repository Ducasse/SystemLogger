Class {
	#name : 'SystemLogExtensionTest',
	#superclass : 'TestCase',
	#category : 'SystemLogger-TestsExtension',
	#package : 'SystemLogger-TestsExtension'
}

{ #category : 'tests' }
SystemLogExtensionTest >> dispatcher [
	^ LogDispatcher current
]

{ #category : 'tests' }
SystemLogExtensionTest >> resetDispatcher [
	LogDispatcher reset
]

{ #category : 'tests' }
SystemLogExtensionTest >> testLogOfTheRightClassIsLogged [
	"self debug: #testLogOfTheRightClassIsLogged"

	self resetDispatcher.
	self dispatcher startAllLoggers.
	ExampleLog example. "and this emit a new log"
	self assert: self dispatcher defaultLogger logs last class equals: ExampleLog.
	
]

{ #category : 'tests' }
SystemLogExtensionTest >> testStringStreamLogger [
	| disk |
	disk := FileSystem memory.
	Log dispatcher 
		addLogger: (StringStreamLogger on: (disk / 'test.log') writeStream) startLogging.
	'test4321' asLog emit.
	self assert: ((disk / 'test.log') readStream contents asString includesSubstring: 'test4321').
]
