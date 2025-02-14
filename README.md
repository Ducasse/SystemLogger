System Logger is an object logger (by opposition to textual logger). 

It was developed as a logger for Pharo. The community chose Beacon which proposes an alternative design.
Still you may want to use SystemLogger. Check the documentation. 

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)


SystemLogger proposes a Pharo solution that focuses on objects. The central concept is the Log object which represents a single logging event. The event can be specialized via subclassing with various types of events. Similar to Toothpick, it features a central object that collects log objects, and has several concrete loggers that consume the log objects through various bindings such as the standard output or a database. The size is also rather tiny, the core containing some 535 lines of code.


## Loading 
The following script installs it in Pharo.

```smalltalk
Metacello new
  baseline: 'SystemLogger';
  repository: 'github://Ducasse/SystemLogger/src';
  load.
```

## If you want to depend on it 

Add the following code to your Metacello baseline or configuration 

```smalltalk
spec 
   baseline: 'SystemLogger' 
   with: [ spec repository: 'github://Ducasse/SystemLogger/src' ].
```
