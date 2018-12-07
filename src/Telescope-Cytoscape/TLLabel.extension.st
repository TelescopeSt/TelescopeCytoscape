Extension { #name : #TLLabel }

{ #category : #'*Telescope-Cytoscape' }
TLLabel class >> cytoscapeAttribute [
	^ #'shape-polygon-points'
]

{ #category : #'*Telescope-Cytoscape' }
TLLabel class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put a label on a connection'
]

{ #category : #'*Telescope-Cytoscape' }
TLLabel class >> polygonPoints [
	^ {(-1 @ 0.7).
	(0.5 @ 0.7).
	(1 @ 0).
	(0.5 @ -0.7).
	(-1 @ -0.7)}
]
