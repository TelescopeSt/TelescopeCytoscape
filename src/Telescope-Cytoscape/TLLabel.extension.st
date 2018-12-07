Extension { #name : #TLLabel }

{ #category : #'*Telescope-Cytoscape' }
TLLabel class >> cytoscapeAttribute [
	^ #'shape-polygon-points'
]

{ #category : #'*Telescope-Cytoscape' }
TLLabel class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put a label on a connection'
]
