Extension { #name : #TLStar }

{ #category : #'*Telescope-Cytoscape' }
TLStar class >> forCytoscape [
	^ 'star'
]

{ #category : #'*Telescope-Cytoscape' }
TLStar class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put a star on a connection'
]
