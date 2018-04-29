Extension { #name : #TLHexagon }

{ #category : #'*Telescope-Cytoscape' }
TLHexagon class >> forCytoscape [
	^ 'hexagon'
]

{ #category : #'*Telescope-Cytoscape' }
TLHexagon class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put an hexagon on a connection'
]
