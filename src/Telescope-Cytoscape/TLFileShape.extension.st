Extension { #name : #TLFileShape }

{ #category : #'*Telescope-Cytoscape' }
TLFileShape class >> cytoscapeAttribute [
	^ #'shape-polygon-points'
]

{ #category : #'*Telescope-Cytoscape' }
TLFileShape class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put a file shape on a connection'
]
