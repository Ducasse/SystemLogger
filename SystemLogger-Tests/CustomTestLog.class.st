Class {
	#name : 'CustomTestLog',
	#superclass : 'BasicLog',
	#instVars : [
		'randomNumber'
	],
	#category : 'SystemLogger-Tests',
	#package : 'SystemLogger-Tests'
}

{ #category : 'as yet unclassified' }
CustomTestLog >> initialize [ 
	super initialize.
	randomNumber := 100000 atRandom.
]
