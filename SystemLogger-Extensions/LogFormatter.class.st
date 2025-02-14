"
Root of log formatters.

in essence a subclass should answer differently to 
	
	formatLog: aLog on: aStream from: aLogger 
	
and you get a new formatter.
"
Class {
	#name : 'LogFormatter',
	#superclass : 'Object',
	#category : 'SystemLogger-Extensions',
	#package : 'SystemLogger-Extensions'
}

{ #category : 'format' }
LogFormatter >> formatLog: aLog from: aLogger [ 

	^ aLog printString
]

{ #category : 'format' }
LogFormatter >> formatLog: aLog on: aStream from: aLogger [ 

	aStream cr.
	aLog printOn: aStream.
]
