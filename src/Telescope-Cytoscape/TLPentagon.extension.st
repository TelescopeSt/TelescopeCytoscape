Extension { #name : #TLPentagon }

{ #category : #'*Telescope-Cytoscape' }
TLPentagon class >> forCytoscape [
	^ 'pentagon'
]

{ #category : #'*Telescope-Cytoscape' }
TLPentagon class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put a pentagon on a connection'
]
