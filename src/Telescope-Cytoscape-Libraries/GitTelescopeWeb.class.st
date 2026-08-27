Class {
	#name : 'GitTelescopeWeb',
	#superclass : 'GitBridge',
	#category : 'Telescope-Cytoscape-Libraries',
	#package : 'Telescope-Cytoscape-Libraries'
}

{ #category : 'class initialization' }
GitTelescopeWeb class >> initialize [
	SessionManager default registerSystemClassNamed: self name
]

{ #category : 'class initialization' }
GitTelescopeWeb class >> resources [
	^ self root / 'resources'
]
