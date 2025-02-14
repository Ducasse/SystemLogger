"
==SystemLogger== is a subclass of ==Logger==. It keeps the log objects in memory. One of its instance is the default system logger associated to the ==LogDispatcher== singleton. We can imagine in the future to change it to support a cyclic structure to hold a maximum amount of log objects.


"
Class {
	#name : 'SystemLogger',
	#superclass : 'Logger',
	#instVars : [
		'logs'
	],
	#category : 'SystemLogger-Core',
	#package : 'SystemLogger-Core'
}

{ #category : 'accessing' }
SystemLogger class >> defaultLogger [

	^ self new name: 'default'; yourself
]

{ #category : 'adding/removing' }
SystemLogger >> addLogHook: aLog [ 

	logs add: aLog

]

{ #category : 'initialization' }
SystemLogger >> initialize [

	super initialize.
	logs := OrderedCollection new: 1000.
]

{ #category : 'testing' }
SystemLogger >> isEmpty [
	
	^ logs isEmpty
]

{ #category : 'accessing' }
SystemLogger >> lastLog [
	
	^ logs last
]

{ #category : 'accessing' }
SystemLogger >> logEntries [

	^ logs
]

{ #category : 'accessing' }
SystemLogger >> logs [

	^ logs
]

{ #category : 'adding/removing' }
SystemLogger >> removeLog: aLog [ 
	
	logs remove: aLog ifAbsent: [nil].
	self announcer announce: (LogRemoved new log: aLog)
]

{ #category : 'adding/removing' }
SystemLogger >> reset [

	logs := OrderedCollection new: 1000.
]
