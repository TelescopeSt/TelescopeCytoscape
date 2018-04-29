Extension { #name : #TLRhomboid }

{ #category : #'*Telescope-Cytoscape' }
TLRhomboid class >> forCytoscape [
	^ 'rhomboid'
]

{ #category : #'*Telescope-Cytoscape' }
TLRhomboid class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put a rhomboid on a connection'
]
