Class {
	#name : 'TestLogObject',
	#superclass : 'Object',
	#instVars : [
		'foo'
	],
	#category : 'SystemLogger-Tests',
	#package : 'SystemLogger-Tests'
}

{ #category : 'as yet unclassified' }
TestLogObject class >> logClass [
	^ CustomTestLog
]

{ #category : 'accessing' }
TestLogObject >> foo [
	^ foo
]

{ #category : 'as yet unclassified' }
TestLogObject >> foo: aString [
	foo := aString
]
