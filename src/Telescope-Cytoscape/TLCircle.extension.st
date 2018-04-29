Extension { #name : #TLCircle }

{ #category : #'*Telescope-Cytoscape' }
TLCircle class >> forCytoscapeConnection [
	^ 'circle'
]

{ #category : #'*Telescope-Cytoscape' }
TLCircle class >> forCytoscapeNode [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Circle is only for connections; use Ellipse'
]
