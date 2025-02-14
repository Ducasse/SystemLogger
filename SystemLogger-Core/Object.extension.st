Extension { #name : 'Object' }

{ #category : '*SystemLogger-Core' }
Object >> asLog [
	^ self class newLog message: self 
]

{ #category : '*SystemLogger-Core' }
Object class >> logClass [
	"Hook supporting the redefinition by object of their associated log.
	When using myObject asLog emit, the logClass will be used and myObject will be passed as message argument."

	^ Log
]

{ #category : '*SystemLogger-Core' }
Object class >> newLog [
	^ self logClass new
]

{ #category : '*SystemLogger-Core' }
Object >> newLog [
	^ self class newLog
]
