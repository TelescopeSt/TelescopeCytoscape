Extension { #name : #TLVisualization }

{ #category : #'*Telescope-Cytoscape' }
TLVisualization >> ensureWebAppVisualizationComponentIsRunning [

	TLWebAppVisualizationComponent ensureIsRunning.
]

{ #category : #'*Telescope-Cytoscape' }
TLVisualization >> openOnWeb [
	self class environment
		at: #OSProcess
		ifPresent: [ :class | 
			| webAppVisualization port |
			self ensureWebAppVisualizationComponentIsRunning.
			webAppVisualization := TLWebAppVisualization singleton.
			webAppVisualization visualization: self.
			WAServerManager default adaptors
				ifEmpty: [ (ZnZincServerAdaptor port: (port := 8080)) start ]
				ifNotEmpty: [ :adaptors | adaptors detect: #isRunning ifFound: [ :anAdaptor | port := anAdaptor server port ] ifNone: [ (ZnZincServerAdaptor port: (port := 8080)) start ] ].
			class command: 'open http://localhost:' , port asString , '/UserVisualization' ]
		ifAbsent: [ self inform: 'Only available if OSProcess is loaded in the image.' ]
]
