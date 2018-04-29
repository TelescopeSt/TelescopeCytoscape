Extension { #name : #WAAdmin }

{ #category : #'*Telescope-Cytoscape' }
WAAdmin class >> isAnAppRegisteredAt: anObject [

	^self defaultDispatcher handlers includesKey: anObject .
]
