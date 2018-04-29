Extension { #name : #TLOctagon }

{ #category : #'*Telescope-Cytoscape' }
TLOctagon class >> forCytoscape [
	^ 'octagon'
]

{ #category : #'*Telescope-Cytoscape' }
TLOctagon class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put an octagon on a connection'
]
