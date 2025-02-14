"
I represent a simple log entity: be it a compilation overrides, an image snapshot or a simple string output.
I collaborate with the current log dispatcher to emit log objects to loggers.

!! I hold the following state 
- timeStamp records the moment the log is created
- level is a kind of emergency level
- message is a message 
- tag indicates a domain to help sorting logs 
- extensions is to offer a dictionary-based API when client to not want to create specific subclasses. 

Several convenient methods exist to create Log objects:

[[[ 
	Log error: 'Damn this is broken'
	Log critical: 'Damn this is really broken'
	Log message: 'Hello it looks we got a trouble'
	Log trace: 'We passed here '
	Log warn: 'the system is still running but you should have look at it'
]]]
If you need to pass more information, use the class side following methods: 
	
Now the default creation messages are:
	=message: =
	=message: tag:= where tag: is a domain to sort logs
	=message: tag: level:= where level indicates an importance level (so far we have critical error warning information trace)
	=message: aMessage tag: aTag level: aLevel timeStamp: aTimeStamp= (normally you should not have to specify the time stamps of the log.)
	
!! Important point.
One of the key responsibility of a log object is to emit the logger to the log dispatcher. However, in general you do it by yourself. The emit message is invoked for you by the creation messages. All the class creation methods use emit. The subclasses may introduce extra information such as policy to display, filtering, extra logging information. They should offer a nice API and invoke the emit message. 

A log can also accept any optional information using key/value  

	Log error: 'Damn this is broken' withExtra: [ :log | log extensionAt: #thisContext put:   thisContext]
	Log error: 'Damn this is broken' withExtra: [ :log | log addExtensions: {#thisContext -> thisContext} ]

!! Design notes.
I'm named Log and not SLLogObject or whatever because I'm the main entry point for a client point of view. 
"
Class {
	#name : 'Log',
	#superclass : 'BasicLog',
	#instVars : [
		'level',
		'tag',
		'extensions'
	],
	#category : 'SystemLogger-Core',
	#package : 'SystemLogger-Core'
}

{ #category : 'convenience' }
Log class >> critical: message [ 
	"Emit a log with message: message at 'critical' level."
	
	^ self message: message level: LogLevel critical
]

{ #category : 'convenience' }
Log class >> critical: message withExtra: aBlock [
	"Emit a log with message: message at 'critical' level."
	
	^ self message: message level: LogLevel critical withExtra: aBlock
			
]

{ #category : 'constants - private' }
Log class >> defaultLogLevel [
	^ LogLevel information
]

{ #category : 'constants - private' }
Log class >> defaultTag [
	^ 'default'
]

{ #category : 'convenience' }
Log class >> error: message [ 
	"Emit a log with message: message at error level."
	^  self message: message level: LogLevel error
]

{ #category : 'convenience' }
Log class >> error: message  withExtra: aBlock [
	"Emit a log with message: message at error level."
	^  self message: message level: LogLevel error withExtra: aBlock
]

{ #category : 'convenience' }
Log class >> info: message [
	"Emit a log with message: message at info level."
	^ self message: message level: LogLevel info
]

{ #category : 'instance creation' }
Log class >> message: aMessage [ 
	"Emit a log with message: message. By default the log level is set to information."
	^ self message: aMessage tag: self defaultTag
]

{ #category : 'instance creation' }
Log class >> message: aMessage level: aLevel [ 
	"Emit a log with message: message, a tag and an information level. A tag is something describing a domain (eg 'compiler') or a given context ('debuging'). 
A level described the importance of the message. So far we have: warm, trace, message error and critical."
	
	^ self message: aMessage level: aLevel withExtra: [ :log ] 
]

{ #category : 'instance creation' }
Log class >> message: aMessage level: aLevel withExtra: aBlock [
	"Emit a log with message: message. By default the log level is set to information."
	^ self message: aMessage tag: self defaultTag level: aLevel withExtra: aBlock
			
]

{ #category : 'instance creation' }
Log class >> message: aMessage tag: aTag [ 
	"Emit a log with message: message and a tag. A tag is something describing a domain (eg 'compiler') or a given context ('debuging'). By default a message level is set to 'information'."
	
	^ self message: aMessage tag: aTag level: self defaultLogLevel
]

{ #category : 'instance creation' }
Log class >> message: aMessage tag: aTag level: aLevel [ 
	"Emit a log with message: message, a tag and an information level. A tag is something describing a domain (eg 'compiler') or a given context ('debuging'). 
A level described the importance of the message. So far we have: warm, trace, message error and critical."
	
	^ self message: aMessage tag: aTag level: aLevel withExtra: [ :log ]
]

{ #category : 'as yet unclassified' }
Log class >> message: aMessage tag: aTag level: aLevel timeStamp: aTimeStamp withExtra: oneArgBlock [
	"Emit a log with message: message, a tag and an information level. A tag is something describing a domain (eg 'compiler') or a given context ('debuging'). 
A level described the importance of the message. So far we have: warm, trace, message error and critical."

	| newLog |
	newLog := self new
		tag: aTag;
		timeStamp: aTimeStamp;
		level: aLevel; 
		message: aMessage;
		yourself.
	oneArgBlock value: newLog.
	^  newLog emit
]

{ #category : 'instance creation' }
Log class >> message: aMessage tag: aTag level: aLevel withExtra: oneArgBlock [
	"Emit a log with message: message, a tag and an information level. A tag is something describing a domain (eg 'compiler') or a given context ('debuging'). 
A level described the importance of the message. So far we have: warm, trace, message error and critical."

	| newLog |
	newLog := self new
		tag: aTag;
		level: aLevel;
		message: aMessage;
		yourself.
	oneArgBlock value: newLog.
	^  newLog emit
]

{ #category : 'instance creation' }
Log class >> message: aMessage tag: aTag withExtra: aBlock [
	"Emit a log with message: message and a tag. A tag is something describing a domain (eg 'compiler') or a given context ('debuging'). By default a message level is set to 'information'."
	
	^ self message: aMessage tag: aTag level: self defaultLogLevel withExtra: aBlock 
]

{ #category : 'instance creation' }
Log class >> message: aMessage withExtra: aBlock [
	"Emit a log with message: message. By default the log level is set to information."
	^ self message: aMessage tag: self defaultTag withExtra: aBlock
			
]

{ #category : 'convenience' }
Log class >> trace: message [ 
	"Emit a log with message: message at trace level."
	
	^ self message: message level: LogLevel trace
]

{ #category : 'convenience' }
Log class >> trace: message withExtra: aBlock [
	"Emit a log with message: message at trace level."
	
	^ self message: message level: LogLevel trace withExtra: aBlock
]

{ #category : 'convenience' }
Log class >> warn: message [
	"Emit a log with message: message at warning level."
	^ self message: message level: LogLevel warning
]

{ #category : 'convenience' }
Log class >> warn: message withExtra: aBlock [
	"Emit a log with message: message at warning level."
	
	^ self message: message level: LogLevel warning withExtra: aBlock
]

{ #category : 'extensions' }
Log >> addExtensions: aBindingCollection [

	aBindingCollection do: [ :each | self extensionAt: each key put: each value ]. 
]

{ #category : 'level' }
Log >> critical [
	"To represent a critical situation."

	level := LogLevel critical
]

{ #category : 'level' }
Log >> debug [
	"To convey a debugging information"

	level := LogLevel debug
]

{ #category : 'level' }
Log >> error [
	"To convey an error."

	level := LogLevel error
]

{ #category : 'extensions' }
Log >> extensionAt: aKey [ 
	"Returns the value of an extension and returns nil if no extension is defined."
	^ self extensionAt: aKey ifAbsent: [ nil ]
]

{ #category : 'extensions' }
Log >> extensionAt: aKey ifAbsent: aBlock [
	"Query the value of an extension and execute the absent block if necessary"
	^ extensions 
		ifNil: aBlock
		ifNotNil: [ extensions at:  aKey ifAbsent: aBlock ]
]

{ #category : 'extensions' }
Log >> extensionAt: aKey put: aValue [
	"Set the value of an extension key."
	extensions ifNil: [ extensions := Dictionary new ].
	^ extensions at:  aKey put: aValue
]

{ #category : 'extensions' }
Log >> extensionKeys [
	"Returns the list of extensions"
	^ extensions 
		ifNil: [ #() ]
		ifNotNil: [ extensions keys]
]

{ #category : 'printing' }
Log >> fullPrintOn: aStream [ 
	
	aStream
		<< '| ';
		<< self level asString ; 
		<< ' | ';
		<< self tag asString; 
		<< ' | ';
		<< self message asString; 
		<< ' - ';
		<< self timeStamp date asString; 
		<< ' '.
		self timeStamp printHMSOn: aStream
]

{ #category : 'level' }
Log >> info [
	"To represent just some information."

	level := LogLevel info
]

{ #category : 'initialization' }
Log >> initialize [

	super initialize.
	self info
]

{ #category : 'accessing' }
Log >> level [
	
	^ level
]

{ #category : 'accessing' }
Log >> level: aSymbolOrInteger [
	
	level := aSymbolOrInteger
			
]

{ #category : 'menus' }
Log >> menus [
	"ugly just to brainstorm and get something working now"
	
	"if you pass a selector requiring an argument, then you will get the logger
	from which this log is displayed in the corresponding UI."
	^ #(('inspect' #inspect))
]

{ #category : 'printing' }
Log >> printOn: aStream [ 
	
	aStream
		<< timeStamp asString;
		<< '| ';
		<< self level asString ; 
		<< ' | ';
		<< self tag asString; 
		<< ' | ';
		<< self message asString.
		
	
]

{ #category : 'default' }
Log >> setDefaultTag [

	tag := self class defaultTag
]

{ #category : 'accessing' }
Log >> tag [
	"Return the tag (a kind of domain) of a log."
	
	^ tag 
]

{ #category : 'accessing' }
Log >> tag: aDomainTag [
	"Useful to short logs based on their domain."
	
	tag := aDomainTag
]

{ #category : 'level' }
Log >> trace [
	"To represent a trace situation."

	level := LogLevel trace
]

{ #category : 'level' }
Log >> warning [
	"To represent just some warning (not really an error)."

	level := LogLevel warning
]

{ #category : 'writing' }
Log >> writeOn: aStream [ 

	self printOn: aStream
]
