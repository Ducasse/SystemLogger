"
I add the possibility to attach an object responsible for formatting log objects.
This can be important for use case where strings in a specific format should be outputted.

I provide three hooks to my subclasses

	- the defaultFormatterClass
	- the way to store object using the storeObject: message
	- the possibility to convert a Log into something else.
	The formatter is called using formatLog: aLog from: aLogger
"
Class {
	#name : 'FormattingLogger',
	#superclass : 'Logger',
	#instVars : [
		'formatter'
	],
	#category : 'SystemLogger-Extensions',
	#package : 'SystemLogger-Extensions'
}

{ #category : 'defaults' }
FormattingLogger class >> defaultFormatter [

	^ LogFormatter new
]

{ #category : 'adding' }
FormattingLogger >> addLogHook: aLogEntry [ 
	"Convert the argument before handling it in some ways."
	self handleConvertedLog: (self convertLog: aLogEntry)
]

{ #category : 'operations' }
FormattingLogger >> convertLog: aLog [

	^ self formatter
		formatLog: aLog
		from: self
]

{ #category : 'defaults' }
FormattingLogger >> defaultFormatter [
	^ self class defaultFormatter
]

{ #category : 'accessing' }
FormattingLogger >> formatter [
	^ formatter ifNil: [ formatter := self defaultFormatter ]
]

{ #category : 'accessing' }
FormattingLogger >> formatter: aFormatter [
	
	formatter := aFormatter
]

{ #category : 'operations' }
FormattingLogger >> handleConvertedLog: anObject [
	"Hook to customize to specify how an object should be stored once converted."

	self subclassResponsibility 
]

{ #category : 'initialize' }
FormattingLogger >> initialize [ 
	super initialize.
	formatter := self defaultFormatter.
]
