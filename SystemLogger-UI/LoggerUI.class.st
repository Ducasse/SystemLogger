"
LoggerUI example

LoggerUI open 

LoggerUI new 
	logger: (LogDispatcher current defaultLogger); 
	openWithSpec 
	
LogDispatcher current defaultLogger
LogDispatcher current startAllLoggers

SLDomainObject new actionWithLoggingMethodContextOtherAPI

SLDomainObject new actionWithLog
"
Class {
	#name : 'LoggerUI',
	#superclass : 'SpPresenter',
	#instVars : [
		'zoom',
		'logList',
		'logger'
	],
	#category : 'SystemLogger-UI',
	#package : 'SystemLogger-UI'
}

{ #category : 'example' }
LoggerUI class >> example [
	"self example"
	
	| cb |
	cb := self new.
	cb logger: (LogDispatcher current defaultLogger).
	Log error: 'this is an error'.
	Log message: 'this is a message only interesting from the logger domain' tag: 'logger domain'. 
	cb open.
	^ cb
]

{ #category : 'example' }
LoggerUI class >> menuLogListAction: aBuilder [
	<loglistMenu>
	
	(aBuilder item: #'Remove')
		keyText: 'x';
		selector: #removeAction.
	(aBuilder item: #'Refresh')
		keyText: 'r';
		selector: #refresh.
	(aBuilder item: #'Select All')
		keyText: 'a';
		selector: #selectAll.
	(aBuilder item: #'This domain')
		keyText: 'd';
		selector: #showOnlyThisDomain.
	(aBuilder item: #'This level')
		keyText: 'l';
		selector: #showOnlyThisLevel.
	(aBuilder item: #'Show all')
		keyText: 'u';
		selector: #unfilterAction;
		withSeparatorAfter
]

{ #category : 'example' }
LoggerUI class >> open [

	^ self new 
		logger: (LogDispatcher current defaultLogger); 
		openWithSpec;
		yourself
]

{ #category : 'menu' }
LoggerUI >> addDiscardMenuItem: aMenu [
	aMenu
		add: 'Discard (d)' translated
		target: self
		selector: #discard:
		argumentList: {(self selectedItem)}.

]

{ #category : 'menu' }
LoggerUI >> addInspectMenuItem: aMenu [
	aMenu
		add: 'Inspect (i)' translated
		target: self
		selector: #inspect:
		argumentList: {(self selectedItem)}.

]

{ #category : 'initialize' }
LoggerUI >> connectPresenters [
	
	logList whenSelectedItemChangedDo: [ :selection |
		selection 
			ifNotNil: [ :log | 
				zoom model: log asInspectorModel ]].
		
]

{ #category : 'layout' }
LoggerUI >> defaultLayout [
	
	" this is probably wrong the original one was
	defaultSpec
	<spec>
	^ SpecLayout composed
		newColumn: [ :row | row
						add: #logList;
					""how do I add splitters""
						addHSplitter;
						newRow: #zoom];
		yourself
	"
	^ SpBoxLayout
		newTopToBottom 
			add: #logList ;
			add: #zoom ;
		yourself
]

{ #category : 'menu' }
LoggerUI >> discard: anItem [

	logger removeLog: anItem.
	"ugly no?"
	self logList items: logger logs.
]

{ #category : 'initialize' }
LoggerUI >> initialExtent [
	"Answer the desired extent for the receiver when it is first opened on the screen.  "

	^ 450 @ 650
]

{ #category : 'initialize' }
LoggerUI >> initialize [

	super initialize.
	SystemLogger announcer weak 
		when: LogAdded 
		send: #newLog:
		to: self. 
	SystemLogger announcer weak 
		when: LogRemoved 
		send: #newLog:
		to: self. 
]

{ #category : 'initialize' }
LoggerUI >> initializePresenters [

	logList := self newList.
	zoom := StInspectorPresenter newApplication: self application. 
	
	
]

{ #category : 'menu' }
LoggerUI >> inspect: anItem [

	anItem inspect
]

{ #category : 'accessing ports' }
LoggerUI >> logList [

	^ logList
]

{ #category : 'accessing' }
LoggerUI >> logger: aLogger [
	aLogger ifNil: [ ^ self ]. "should be removed later"
	logger := aLogger.
	self logList items: aLogger logs.
	
]

{ #category : 'menu' }
LoggerUI >> menu: aMenu [

	self selectedItem ifNil: [ ^ aMenu ].
	self addInspectMenuItem: aMenu.
	self addDiscardMenuItem: aMenu.
	self selectedItem menus 
			do: [ :each | aMenu 
								add: each first 
								target: self selectedItem 
								selector: each second 
								argument: logger  ].
	^ aMenu
]

{ #category : 'initialize' }
LoggerUI >> newLog: aLog [

	self logger: logger
]

{ #category : 'menu' }
LoggerUI >> removeAction [
]

{ #category : 'accessing' }
LoggerUI >> selectedItem [

	^ self logList selectedItem
]

{ #category : 'accessing' }
LoggerUI >> title [

	^ 'Logger: ',  logger name
]

{ #category : 'accessing ports' }
LoggerUI >> zoom [

	^ zoom
]
