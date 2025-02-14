Class {
	#name : 'CustomTestLogLevel',
	#superclass : 'LogLevel',
	#category : 'SystemLogger-Tests',
	#package : 'SystemLogger-Tests'
}

{ #category : 'as yet unclassified' }
CustomTestLogLevel class >> foo [
	<logLevel>
	^ self levels
		at: #foo
		ifAbsentPut: [ 
			self new 
				name: #foo;
				shortName: #foo;
				severity: 555 ]
]
