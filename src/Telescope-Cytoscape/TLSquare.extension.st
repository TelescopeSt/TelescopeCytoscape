Extension { #name : #TLSquare }

{ #category : #'*Telescope-Cytoscape' }
TLSquare class >> forCytoscapeConnection [
	^ 'square'
]

{ #category : #'*Telescope-Cytoscape' }
TLSquare class >> forCytoscapeNode [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Square is only for connections; use rectangle'
]
