"
LogRemoved is an annoucement raised when an log is removed from a logger.
"
Class {
	#name : 'LogRemoved',
	#superclass : 'Announcement',
	#instVars : [
		'log'
	],
	#category : 'SystemLogger-Core',
	#package : 'SystemLogger-Core'
}

{ #category : 'accessing' }
LogRemoved >> log [
	^ log
]

{ #category : 'accessing' }
LogRemoved >> log: anObject [
	log := anObject
]
