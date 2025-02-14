"
LogAddedd is an annoucement raised when an log is removed from a logger.
"
Class {
	#name : 'LogAdded',
	#superclass : 'Announcement',
	#instVars : [
		'log'
	],
	#category : 'SystemLogger-Core',
	#package : 'SystemLogger-Core'
}

{ #category : 'accessing' }
LogAdded >> log [
	^ log
]

{ #category : 'accessing' }
LogAdded >> log: anObject [
	log := anObject
]
