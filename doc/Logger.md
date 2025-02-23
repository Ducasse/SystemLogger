# An Extensible Object Logger

There are several textual logging frameworks available for Pharo: SimplerLogger, PaulThePoulpe, TinyLogger, and ToothPick. Toothpick is developed by Joseph Pelrine and is one the most advanced and has a nice documentation. 
Paul le Poulp is another interesting framework
`http://concretetypeinference.blogspot.fr/2012/06/pharo-logger-aka-paul-octopus-or-le.html`. 
Finally there is also SimpleLog developed by Goran Krampe, Magnus Kling and Keith P. Hodges available at squeaksource.com.

So you can wonder why there is a need for yet another one. Well let us think a bit about the domain. Often
logging is associated with outputting strings into a file and using grep to make sense out of them. Why
only focusing on strings? As an object-oriented programmer we all know that strings are dead objects. With
strings we can do exciting operations like computing their size, concatenating them and replacing all the
'a' buy 'z'. But this is a bit limited. We have objects and they can be converted into strings so we have
only to win. SystemLogger is an easy to use, very lightweight, and highly configurable object logging
framework. SystemLogger manipulates objects and this opens a complete new set of scenario and in addition
it is compatible with the idea of a string logger.

Note that some ideas of this framework will be integrated in Beacon the future logging framework of Pharo.


### Starting with an example
With SystemLogger logging a message is as simple as sending the message `message:` to the class `Log`.

```
	Log message: 'Hello it looks we got a trouble'
```

Let us step back one minute. `message:` is equivalent to the old `Transcript show:`. Note however that what is cool with SystemLogger and dealing with objects is that you should not be concerned about the handling of carriage return. Why? Simply because log objects do not have this notion and when we want to transform them into strings, then the formatter will do it for you. We are sure that you start understanding that dealing with objects is the way to go and will make our live easier.


## About any object as message carrier. 
Note in addition that the argument passed to the message `message:` could be any object and not necessarily a string. 
A possible way to define a new log event is to use the `asLog` message as follow:

```
	myObject asLog emit
```

When using such way of creating logs, the `logClass` message associated to the class of myObject is used to determine the class of the log (by default Log) and myObject is passed as message of the created log event. SystemLogger provides the possibility to defines the class of the log event that will be created. Just redefine the class method  `logClass` on your domain object. 

Finally note that the first form of logging event is nice because it does not expose to the user that he has to explicitly send the `emit` message. 





When you are debugging and want to identify more specific paths in your code, issuing a message is a bit broad and it will be mixed with all the other messages. To help you finding your ways among the collected logs, you can also use the message `trace:`.

It looks simple and so far it is. What you see is that as a normal user of the log objects you just have to express what you want.
Then the system takes care about collecting the logs into a logger as we will see later. 

Now you may want to raise log of different importance. `Log` provides some predefined ways to express the severity of your log: `error:`, `critical:`, `message:`, `trace:` and `warn:`. It follows sysLog order. 

``` 
	Log error: 'Damn this is broken'.
	Log critical: 'Damn this is really broken'.
	Log message: 'Hello it looks we got a trouble'.
	Log trace: 'We passed here '.
	Log warn: 'the system is still running but you should have look at it'.
```

### Log creation messages
In addition to simple creation messages, `Log` proposes other creation messages to improve the filtering of logs.

The default creation messages are in addition to the simple `message:`.

- `message: tag:` where tag: is a domain to sort logs. It will help you 
- `message: tag: level:` where level indicates an importance level. So far we have the following levels: critical error warning information trace that you can obtain doing `LogLevel all`.
- `message: aMessage tag: aTag level: aLevel timeStamp: aTimeStamp`. Note that normally you should not have to specify the time stamps of the log since this is done automatically. 

Here is an example
```
(Log 
		message: 'From My Framework' 
		tag: 'Compiler' 
		level: LogLevel error)
```


### Extra information
A log can also accept any optional information using key/value  

```
	Log error: 'Damn this is broken' withExtra: [ :log | log extensionAt: #thisContext put:   thisContext]
	Log message: 'Not totally broken' withExtra: [ :log | log addExtensions: {#thisContext -> thisContext} ]
```


Since we do not know the exact scenario the Log class proposes the following messages to handle extra information.

- `addExtensions: aPair` adds an  extension and its value specified as a pair
- `extensionAt: aSymbol` and `extensionAt: aSymbol ifAbsent: aBlock` queries the value of an extension and execute the absent block if necessary.
- `extensionAt: aSymbol put: aValue` set the value of a key.
- `extensionKeys` returns the list of extensions.


### Three core classes

SystemLogger core is composed about 3 classes: `Log`, `SystemLogger` and `LogDispatcher`. The two first ones are public while the last one is a private class that the end user does not have toas shown in Figure *logCore* know. It raises also announcements: `LogAdded` and `LogRemoved`.

In addition, `LogLevel` encapsulates the logic of defining a level. A logLevel represents a level of severity in log messages. There are default log levels which can be used via class methods such as `critical`, `error`, `warning`, `information`, `debug` and `trace`.

![Core classes %width=50|anchor=logCore](figures/logCore.png)



### Core element one: Log objects

Log objects are represented by the classes `Log` and its superclass `BasicLog`. `Log` is named like that because we wanted to have it as short as possible to write concise code.  `Log` represents a simple log entity: be it a compilation override, an image snapshot or a simple string output. It collaborates with the current log dispatcher to emit log objects to loggers.

Note that `Log` is named `Log` and not `SLLogEntry` or whatever because it is the main entry point for a client point of view.
In fact `Log` instance level represents the behavior of a log entry object and the class level act as a log entry generator.

	
#### Important point. 
One of the key responsibilities of a log object is to emit the logger to the log dispatcher. However, in general, you do it by yourself. The `emit` message is sent for you by the creation messages. All the class creation methods use emit. The subclasses may introduce extra information such as policy to display, filtering, extra logging information. They should offer a nice API and send the `emit` message. 


 `BasicLog`, the superclass of `Log` represents a simpler log object consisting only of a timeStamp and a message.   More specialized log classes may be derived from this class like the default `Log` class does. Usually as a normal user you will not use directly `BasicLog` but `Log` because it proposes a better API.

```
BasicLog message: 'Test message string'
```


As already mentioned above, a message can be any object and it is not limited to be a string. The following example shows that we can pass a stack as message. 

```
BasicLog message: thisContext sender
```



### Core element two: LogDispatcher

When a log object is created, it is passed to the system log dispatcher. There is only one logDispatcher in the system, it is an instance of `LogDispatcher` and can be accessed `LogDispatcher current`. His role is to dispatch the emitted log objects to the system loggers that registered to the dispatcher. 

There is one favorite system logger associated to the current dispatcher. It is the main default logger. It can be accessed by the following expression: `self current defaultLogger`. 

In addition, we can add loggers to the current dispatcher using `addLogger:`. A dispatcher will dispatch log to any available loggers. 

```
	LogDispatcher current addLogger: (MySpecialLogger name: 'test1').
```

Note that from an access point of view `LogDispatcher` is a private class and it is much better to access it via the `Log` class using the dispatcher message as follow:

```
	Log dispatcher addLogger: (MySpecialLogger name: 'test1').
```

Similarly you can remove a system logger using the `removeLogger:` or `removeLoggerNamed:` messages.
	
Finally all loggers can be stopped to receive log objects from the log dispatcher and started using the messages `startAllLoggers` and `stopAllLoggers`. 


### Core element three: SystemLogger

The third player in the framework is a logger. A logger is responsible to decide if it is interested to handle log objects and if this is case to handle them according to its function. 

### Logger

 `Logger` is the abstract superclass of system loggers. It has a name. 

It defined the following messages:

- `startLogging` and `stopLogging` enable and respectively disable the handling of log objects.
- `filter: aBlock` to specify the condition that the log objects should satisfy to be handled by the system logger. 
- `addLog: aLog` sent by the log dispatcher.
- `addLogHook: aLog` is a hook message that specifies the effective action performed when handling a log object.
- `reset` flushes the log objects if any that could have been hold by the receiver.

### SystemLogger

 `SystemLogger` is a subclass of `Logger`. It keeps the log objects in memory. One of its instance is the default system logger associated to the `LogDispatcher` singleton. It can be accessed via `Logger default`. There is no need to add explicitly SystemLogger instances to the dispatcher because the system does it automatically (since SystemLogger plays the special role to make sure that all the system logs are recorded).

We imagine in the future we will change `SystemLogger` to use a cyclic structure to hold a maximum amount of log entries.






## About LogLevels

As we saw you can raise logs of different severities: `error:`, `critical:`, `message:`, `trace:` and `warn:`.  `LogLevel` represents such a severity. We follow the severity levels of syslog 0 being the most severe and 7 the least. 


SysLog defines severity as follow: 


|!Code|!Severity|!Keyword|!Description|!General Description|

|{0	|{Emergency	emerg (panic)|{	System is unusable. |{A "panic" condition usually affecting multiple apps/servers/sites. At this level it would usually notify all tech staff on call.
|{1	|{Alert|{alert|{Action must be taken immediately.|{Should be corrected immediately, therefore notify staff who can fix the problem. An example would be the loss of a primary ISP connection.
|{2|{Critical|{crit|{Critical conditions.|{Should be corrected immediately, but indicates failure in a secondary system, an example is a loss of a backup ISP connection.
|{3|{Error|{err (error)|{Error conditions.|{Non-urgent failures, these should be relayed to developers or admins; each item must be resolved within a given time.
|{4|{Warning|{warning (warn)|{Warning conditions.|{Warning messages, not an error, but indication that an error will occur if action is not taken, e.g. file system 85% full - each item must be resolved within a given time.
|{5|{Notice|{notice|{Normal but significant condition.|{Events that are unusual but not error conditions - might be summarized in an email to developers or admins to spot potential problems - no immediate action required.
|{6|{Informational|{info|{Informational messages.|{Normal operational messages - may be harvested for reporting, measuring throughput, etc. - no action required.
|{7|{Debug|{debug|{Debug-level messages.|{Info useful to developers for debugging the application, not useful during operations.



A convenience method `LogLevel>>orMoreSevere` allows one to express that we are interested
in a given level or more severe ones. 

```
aLogger filter: LogLevel warning orMoreSevere
```

### First useful extensions

The first extension is to provide a system logger that can emit strings to our lovely Transcript. 
The idea there is that in addition to log objects to the `SystemLogger` we would like that the system
create a textual trace in the Transcript as in the old days. 

The package already defines it. Now we will simply explain some key aspects of the solution. `StringStreamLogger` is a special logger. It is a logger that emits formatted strings into a stream. It subclasses the class `FormattingFormatter` and add the notion of stream as show in Figure *logExtension*.


![A first extension %width=50|label=logExtension](figures/logExtension.png)


```
FormattingLogger << #StringStreamLogger
	slots: { #stream };
	package: 'SystemLogger-Extensions-StringOutputter'
```

The class `FormattingLogger` is a subclass of `Logger` (and not `SystemLogger`) that simply 
pass the logs object to a formatter before storing them. 


```
FormattingLogger>>addLogHook: aLog 

	self handleConvertedLog: (self convertLog: aLog)

FormattingLogger>>handleConvertedLog: anObject
	"Hook to customize to specify how an object should be stored once converted."

	self subclassResponsibility

FormattingLogger>>convertLog: aLog
	^ self formatter
		formatLog: aLog
		from: self 
```

Note that this design decomposes the actual formatting from the storing: it is possible to then store on different media the formatted version of our log objects. `StringStreamLogger` will store formatted logs in a stream but other subclasses may store the items into a database.


A default formatter is created when none if specified. It is an instance of `LogFormatter`. `LogFormatter` is a simple class that defines two methods: `formatLog:from:` and `formatLog:on:from:`.
The first one just returns a formatted string for a log object, while the second one pushes a formatted string to the argument stream. 

```
LogFormatter>>formatLog: aLog from: aLogger 

	^ aLog printString
```


```
LogFormatter>>formatLog: aLog on: aStream from: aLogger 

	aStream cr.
	aLog printOn: aStream.
```

Now we are ready to define the behavior of `StringStreamLogger`. We redefine the `handleConvertedLog:` method to write to a stream that by default is defined to return Transcript. 


```
StringStreamLogger>>handleConvertedLog: aLog
	
	self stream cr.
	self stream << (formatter formatLog: aLog from: self)
```


```
StringStreamLogger class>>defaultStream
	^ Transcript
```


### Registering a new logger. 

Now we declare this new logger using the message `addLoger:` as follow. 

```
| logger |
logger := StringStreamLogger new.
Log dispatcher addLogger: logger.
Log dispatcher startAllLoggers.
```





### Extensions

SystemLogger has been nicely extended to integrate with Zinc. The extension is simple and just based on a single class `ZincSystemLogListener`. `ZincSystemLogListener`, a subclass of `ZnLogListener` bridges Zinc log events to SystemLogger. it can be used with e.g. ZnClient or ZnServer. 


Here is an example showing how to use it.

```
| client |
client := ZnClient new url: 'http://www.google.de'.
client log addListener: ZincSystemLogListener new.
client get
```


A log event emitted by Zinc logging is received and put into the SystemLogger for dispatching. The message `tag:` can be used to add a domain/tag to the logging message. By doing 

```
Log toTranscript
```

and repeating the ZnClient code above the messages should be visible in the Transcript window. To reduce the verbose logging do

```
(Logger named: 'transcript') filter: LogLevel info orMoreSevere
```



### Conclusion
This simple frameworks is the foundation to get modern object-oriented logs and it opens a complete space to future ideas. 


