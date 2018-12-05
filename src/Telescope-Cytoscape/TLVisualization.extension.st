Extension { #name : #TLVisualization }

{ #category : #'*Telescope-Cytoscape' }
TLVisualization >> ensureWebAppVisualizationComponentIsRunning [

	TLWebAppVisualizationComponent ensureIsRunning.
]

{ #category : #'*Telescope-Cytoscape' }
TLVisualization >> openOnWeb [
	| webAppVisualization port url |
	self ensureWebAppVisualizationComponentIsRunning.
	webAppVisualization := TLWebAppVisualization singleton.
	webAppVisualization visualization: self.
	WAServerManager default adaptors
		ifEmpty: [ (ZnZincServerAdaptor port: (port := 8085)) start ]
		ifNotEmpty: [ :adaptors | adaptors detect: #isRunning ifFound: [ :anAdaptor | port := anAdaptor server port ] ifNone: [ (ZnZincServerAdaptor port: (port := 8085)) start ] ].
	url := 'http://localhost:' , port asString , '/UserVisualization'.
	self flag: #pharo6.
	SystemVersion current major < 7
		ifTrue: [ self class environment
				at: #OSProcess
				ifPresent: [ :class | class command: 'open http://localhost:' , port asString , '/UserVisualization' ]
				ifAbsent: [ self inform: 'Open ' , url , ' or install OSProcess.' ] ]
		ifFalse: [ WebBrowser openOn: url ]
]
