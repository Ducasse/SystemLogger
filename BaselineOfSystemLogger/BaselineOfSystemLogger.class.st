"
Baseline for Beacon - a slim logging engine based entirely on Announcements
"
Class {
	#name : 'BaselineOfSystemLogger',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSystemLogger-Core',
	#package : 'BaselineOfSystemLogger',
	#tag : 'Core'
}

{ #category : 'baselines' }
BaselineOfSystemLogger >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			package: #'SystemLogger-Core';
			package: #'SystemLogger-Tests' with: [
				spec requires: #('SystemLogger-Core' ). ];
			
			package: #'SystemLogger-Extensions' with: [ spec requires: #('SystemLogger-Core') ];
			package: #'SystemLogger-TestsExtensions' with: [ spec requires: #('SystemLogger-Extensions') ];
			
			package: #'SystemLogger-SysLogSender' with: [ spec requires: #('SystemLogger-Core') ];
			package: #'SystemLogger-UI' with: [ spec requires: #('SystemLogger-Core') ].

		spec 		
			group: 'Core' with: #('SystemLogger-Core' );
			group: 'default' with: #('SystemLogger-Core' 'SystemLogger-Tests' 'SystemLogger-Extensions' 'SystemLogger-TestsExtension' 'SystemLogger-UI' 'SystemLogger-SysLogSender'). ].
]
