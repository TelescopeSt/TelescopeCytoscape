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
		ifEmpty: [ (ZnZincServerAdaptor port: (port := 8087)) start ]
		ifNotEmpty: [ :adaptors | adaptors detect: #isRunning ifFound: [ :anAdaptor | port := anAdaptor server port ] ifNone: [ (ZnZincServerAdaptor port: (port := 8087)) start ] ].
	url := 'http://localhost:' , port asString , '/UserVisualization'.
	self flag: #pharo6.
	self flag: #pharo7.
	self class environment
		at: #WebBrowser
		ifPresent: [ :class | class openOn: url ]
		ifAbsent: [ self class environment at: #OSProcess ifPresent: [ :class | class command: 'open ' , url ] ifAbsent: [ self inform: 'Open ' , url , ' or install WebBrowser/OSProcess.' ] ]
]
