Extension { #name : #TLMultiChoiceMenuInteraction }

{ #category : #'*Telescope-Cytoscape' }
TLMultiChoiceMenuInteraction >> forCytoscapeForDrawable: aTLDrawable [
	^ (super forCytoscapeForDrawable: aTLDrawable)
		at: #subMenu put: ((self choicesListForDrawable: aTLDrawable) collect: self displayBlock);
		yourself
]
