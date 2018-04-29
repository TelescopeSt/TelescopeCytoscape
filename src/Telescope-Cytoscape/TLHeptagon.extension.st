Extension { #name : #TLHeptagon }

{ #category : #'*Telescope-Cytoscape' }
TLHeptagon class >> forCytoscape [
	^ 'heptagon'
]

{ #category : #'*Telescope-Cytoscape' }
TLHeptagon class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put an heptagon on a connection'
]
