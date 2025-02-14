"
Imagine that your system wants to add specific Log item into the default logger. 

(ExampleLog 
	message: 'From My Framework' 
	tag: 'Compiler' 
	level: ExampleLog errorLevelString 
	timeStamp: DateAndTime)
"
Class {
	#name : 'ExampleLog',
	#superclass : 'Log',
	#category : 'SystemLogger-TestsExtension',
	#package : 'SystemLogger-TestsExtension'
}

{ #category : 'example' }
ExampleLog class >> example [
	"self example"
	
	^ (ExampleLog 
		message: 'From My Framework' 
		tag: 'Compiler' 
		level: LogLevel error)
]

{ #category : 'menus' }
ExampleLog >> deleteFrom: aLogger [

	aLogger removeLog: self.
]

{ #category : 'menus' }
ExampleLog >> menus [

	^ super menus , #(('Kill me' #deleteFrom: ))
]
