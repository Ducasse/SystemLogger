"
May be the Log class should be extended with the sender notion?
"
Class {
	#name : 'SysLogFormatter',
	#superclass : 'LogFormatter',
	#instVars : [
		'converter'
	],
	#category : 'SystemLogger-SysLogSender',
	#package : 'SystemLogger-SysLogSender'
}

{ #category : 'accessing' }
SysLogFormatter >> converter [
	^ converter
]

{ #category : 'accessing' }
SysLogFormatter >> converter: anObject [
	converter := anObject
]

{ #category : 'format' }
SysLogFormatter >> formatLog: aLog from: aLogger [
	"timestamp is rounded because the syslog format has only second precision"
	| stream  |
	stream := MultiByteBinaryOrTextStream on: ByteArray new.
			
	stream ascii.
	"write priority"
	self writePriority: (aLogger facility + aLog level severity) on: stream.
	"write header consisting of timestamp and host"
	self writeTimestamp: aLog timeStamp on: stream.
	stream
		nextPut:     Character space;
		nextPutAll:  aLogger hostName;
		nextPut:     Character space.
	"syslog format ends here. Now we write the message part"
	self writeMessageFrom: aLog on: stream.
	stream position: 0.
	^ stream upToEnd
]

{ #category : 'testing' }
SysLogFormatter >> hasUtf8Converter [
	^  converter class encodingNames includes: 'utf-8'
]

{ #category : 'writing' }
SysLogFormatter >> writeEncodedString: aString on: aStream [
	"according to RFC 5424 a BOM needs to be written if the encoded string
	is utf-8 encoded"
	"removed for now. This is a mismatch between RFC3164 and RFC5424. As those two
	are not compatible this should be separated in two different formatters. Now we just
	encode utf-8 to be able to transport proper strings"
	"self hasUtf8Converter ifTrue: [
		converter class writeBOMOn: aStream ]."
	converter nextPutByteString: aString toStream: aStream
]

{ #category : 'writing' }
SysLogFormatter >> writeMessageFrom: aLog on: aStream [
	"the message part is not specified in the syslog protocol and can be any custom message.
	This message is a common format to write a tag/domain, a severity and the text of the message"
	aLog tag ifNotNil: [ 
		aStream
			nextPutAll: aLog tag asString;
			nextPutAll: ': ' ].
	aStream
			nextPutAll:  aLog level shortName asUppercase ;
			nextPutAll: ': '.
	aStream binary.
	self writeEncodedString: aLog message asString on: aStream
]

{ #category : 'writing' }
SysLogFormatter >> writePriority: aNumber on: aStream [
	aStream 
		nextPut: $<;
		nextPutAll: aNumber asString;
		nextPut: $>
]

{ #category : 'writing' }
SysLogFormatter >> writeTimestamp: aDateAndTime on: aStream [
	|  dayOfMonth |
	dayOfMonth := aDateAndTime dayOfMonth .
	aStream 
		nextPutAll: aDateAndTime monthAbbreviation;
		nextPut: Character space;
		nextPutAll: (dayOfMonth asString padLeftTo: 2);
			nextPut: Character space.
		aDateAndTime rounded asTime print24: true on: aStream.
]
