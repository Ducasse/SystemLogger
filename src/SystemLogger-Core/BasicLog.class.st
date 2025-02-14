"
I represent a basic log object consisting only of a timeStamp and a message. All specialized log classes should be derived from me like the default Log class

! I hold the following state 
- timeStamp records the moment the log is created
- message is a message. Note that it can be any kind of object. 
	
!! Important point.
The key protocol is ==emit==. It is in charge to emit the log instance to the current dispatcher.  You do not have to do it by yourself. This is not the responsibility of the client to emit a log, it is the Log itself. 

!! Usage

(BasicLog message: 'Test message string') emit
	
"
Class {
	#name : 'BasicLog',
	#superclass : 'Object',
	#instVars : [
		'timeStamp',
		'message'
	],
	#category : 'SystemLogger-Core',
	#package : 'SystemLogger-Core'
}

{ #category : 'private' }
BasicLog class >> dispatcher [
	^ LogDispatcher current
]

{ #category : 'convenience' }
BasicLog class >> message: message [ 
	"Emit a log with message: message."
	^ self new 
		message: message;
		emit
			
]

{ #category : 'actions' }
BasicLog >> emit [
	"This method is designed like that so that the class can be extended 
	with different behavior and still the dispatcher is hidden.
	Indeed we could have moved creation API to the dispatcher but it did not
	work well when extending this class."
	
	self class dispatcher addLog: self.
]

{ #category : 'initialization' }
BasicLog >> initialize [

	super initialize.
	self now

]

{ #category : 'accessing' }
BasicLog >> message [
	"Return an object representing the message attached to the receiver"
	
	^ message
]

{ #category : 'accessing' }
BasicLog >> message: anObject [
	"anObject can be any kind of object and not just a plain string."
	message := anObject
]

{ #category : 'initialization' }
BasicLog >> now [

	timeStamp := DateAndTime now.
]

{ #category : 'printing' }
BasicLog >> printOn: aStream [ 
	
	aStream
		<< timeStamp asString;
		<< ' | ';
		<< self message asString.
		
	
]

{ #category : 'accessing' }
BasicLog >> timeStamp [
	"returns a aDateAndTime"
	^ timeStamp
]

{ #category : 'accessing' }
BasicLog >> timeStamp: aDateAndTime [
	
	timeStamp := aDateAndTime
]
