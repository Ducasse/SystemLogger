System Logger is an object logger (by opposition to textual logger). 

It was developed as a logger for Pharo. The community chose Beacon which proposes an alternative design.
Still you may want to use SystemLogger. Check the documentation. 

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)

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
