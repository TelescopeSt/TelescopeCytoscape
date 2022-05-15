Extension { #name : #TLClientInteraction }

{ #category : #'*Telescope-Cytoscape' }
TLClientInteraction >> forCytoscapeForDrawable: aTLCompositeNode [
	| data |
	data := Dictionary new.
	data at: #eventType put: self eventType.
	fctName ifNil: [ data at: #script put: self action scriptDSLAsJs ].
	data at: #fctName put: self functionName.
	^ data
]

{ #category : #'*Telescope-Cytoscape' }
TLClientInteraction >> functionName [
	^ fctName ifNil: [ fctName := 'fct' , self class nextId asString ]
]
