Extension { #name : 'Log' }

{ #category : '*SystemLogger-Extensions' }
Log class >> toTranscript [
	(self dispatcher loggerNamed: 'transcript') ifNil: [  
		self dispatcher 
			addLogger: (StringStreamLogger new 
				name: 'transcript';
				startLogging) ]
]
