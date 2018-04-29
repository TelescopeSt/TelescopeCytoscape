Extension { #name : #TLFolderShape }

{ #category : #'*Telescope-Cytoscape' }
TLFolderShape class >> cytoscapeAttribute [
	^ #'shape-polygon-points'
]

{ #category : #'*Telescope-Cytoscape' }
TLFolderShape class >> forCytoscapeConnection [
	^ TLCytoscapeNotSupportedFunctionalityException signal: 'Impossible to put a folder shape on a connection'
]
