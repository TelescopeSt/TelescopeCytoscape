Extension { #name : #TLDoubleLineStyle }

{ #category : #'*Telescope-Cytoscape' }
TLDoubleLineStyle class >> forCytoscapeConnection [
	"Not supported for connections"
	
	^ ''
]

{ #category : #'*Telescope-Cytoscape' }
TLDoubleLineStyle class >> forCytoscapeNode [
	^ #double
]
