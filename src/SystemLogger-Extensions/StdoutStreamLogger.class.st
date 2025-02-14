"
A StdoutStreamLogger is a string based logger using Stdout as output.

| logger |
logger := StdoutStreamLogger new.
LogDispatcher current addLogger: logger.
LogDispatcher current startAllLoggers.

"
Class {
	#name : 'StdoutStreamLogger',
	#superclass : 'StringStreamLogger',
	#category : 'SystemLogger-Extensions-StringOutputter',
	#package : 'SystemLogger-Extensions',
	#tag : 'StringOutputter'
}

{ #category : 'accessing' }
StdoutStreamLogger >> stream [

	^ Stdio stdout

]
