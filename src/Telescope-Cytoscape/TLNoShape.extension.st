Extension { #name : #TLNoShape }

{ #category : #'*Telescope-Cytoscape' }
TLNoShape class >> forCytoscape [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'It is not possible to have a node without shape in cytoscape'
]

{ #category : #'*Telescope-Cytoscape' }
TLNoShape class >> forCytoscapeConnection [
	^ 'none'
]
