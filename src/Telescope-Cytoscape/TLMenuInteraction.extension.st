Extension { #name : #TLMenuInteraction }

{ #category : #'*Telescope-Cytoscape' }
TLMenuInteraction >> forCytoscapeForDrawable: aTLDrawable [
	^ Dictionary with: 'title' -> self title
]
