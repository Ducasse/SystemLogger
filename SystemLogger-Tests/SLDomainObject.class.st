"
I represent some objects performing some actions and creating logs. 
"
Class {
	#name : 'SLDomainObject',
	#superclass : 'Object',
	#category : 'SystemLogger-Tests',
	#package : 'SystemLogger-Tests'
}

{ #category : 'actions' }
SLDomainObject class >> messageString [
	^ 'action with log is executed'
]

{ #category : 'actions' }
SLDomainObject >> logCreationUsingAddLogLowLevelAPI [
	"self new logCreationUsingAddLogLowLevelAPI"
	LogDispatcher current
		addLog:
			(self class messageString asLog
				tag: #SLDomainObject;
				info).
	^ true
]

{ #category : 'actions' }
SLDomainObject >> logCreationUsingExplicitEmitAPI [
	"to understand the system can work in presence of extension
	let us try with extension of already existing accessor methods"

	(Log new
		tag: #SLDomainObject;
		info;
		message: self class messageString;
		addExtensions: {  #context -> thisContext };
		emit ).
	^ true
]

{ #category : 'actions' }
SLDomainObject >> logCreationWithExtensionUsingExplicitEmitAPI [
	"to understand the system can work in presence of extension
	let us try with extension of already existing accessor methods"

	LogDispatcher current
		addLog:
			(Log new
				tag: #SLDomainObject;
				info;
				message: self class messageString;
				extensionAt: #context put: thisContext).
	^ true
]
