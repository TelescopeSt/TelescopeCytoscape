Extension { #name : #TLArrow }

{ #category : #'*Telescope-Cytoscape' }
TLArrow class >> forCytoscapeConnection [
	^ 'triangle-backcurve'
]

{ #category : #'*Telescope-Cytoscape' }
TLArrow class >> forCytoscapeNode [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Arrow is only usable for connections'
]
