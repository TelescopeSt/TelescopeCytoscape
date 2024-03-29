"
I am the command for a new node creation
"
Class {
	#name : #TLVisualizationAddNodeCommand,
	#superclass : #TLVisualizationDrawableCommand,
	#instVars : [
		'virtualNode'
	],
	#category : #'Telescope-Cytoscape-Commands'
}

{ #category : #command }
TLVisualizationAddNodeCommand class >> command [
	^ #add
]

{ #category : #initialization }
TLVisualizationAddNodeCommand >> customizeFromInteractions: aCollectionOfInteractions forNode: aTLNode [
	self
		mouseOverInteraction:
			(aCollectionOfInteractions
				anySatisfy: [ :interaction | 
					interaction isClientSide not
						and: [ interaction action isPopUp not
								and: [ interaction shouldOccursOn: 'mouseOver' with: aTLNode ] ] ]).
	self dropInteraction: (aCollectionOfInteractions anySatisfy: #isDrop).
	self
		popUp:
			(aCollectionOfInteractions
				detect: [ :interaction | 
					interaction isClientSide not
						and: [ interaction action isPopUp
								and: [ interaction condition value: aTLNode ] ] ]
				ifFound: [ :interaction | 
					[ interaction forCytoscapeFromNode: aTLNode ]
						on: TLNilOrEmptyTextException
						do: [ nil ] ]
				ifNone: [ nil ]).
	self
		menu:
			(aCollectionOfInteractions
				select: [ :interaction | interaction shouldOccursOn: #menu with: aTLNode ]
				thenCollect: [ :anInteraction | anInteraction forCytoscapeForDrawable: aTLNode ]).
	self
		clientSideInteractions:
			(aCollectionOfInteractions
				select:
					[ :interaction | interaction shouldOccursOn: #client with: aTLNode ]
				thenCollect: [ :anInteraction | anInteraction forCytoscapeForDrawable: aTLNode ])
]

{ #category : #testing }
TLVisualizationAddNodeCommand >> isAddingCommand [
	^ true
]

{ #category : #json }
TLVisualizationAddNodeCommand >> neoJsonOn: writer [
	| data |
	data := {(#id -> self nodeId)} asDictionary.
	self virtualNode hasParentNode
		ifTrue: [ data at: #parent put: self virtualNode parentNode nodeId ].
	writer
		writeMapStreamingDo: [ :jsonMapWriter | 
			jsonMapWriter writeKey: #group value: #nodes.
			jsonMapWriter writeKey: #data value: data.
			self virtualNode hasChildren
				ifFalse: [ 
					jsonMapWriter
						writeKey: #position
						value:
							{(#x -> self virtualNode cytoscapePosition x).
							(#y -> self virtualNode cytoscapePosition y)} asDictionary ].
			jsonMapWriter writeKey: #mouseClientInteractions value: self clientSideInteractions.
			jsonMapWriter writeKey: #mouseOverInteraction value: self mouseOverInteraction.
			jsonMapWriter writeKey: #dropInteraction value: self dropInteraction.
			self popUp ifNotNil: [ jsonMapWriter writeKey: #popUp value: self popUp ].
			jsonMapWriter writeKey: #style value: self style.
			self menu ifNotEmpty: [ jsonMapWriter writeKey: #menu value: self menu ] ]
]

{ #category : #accessing }
TLVisualizationAddNodeCommand >> nodeId [
	^ self virtualNode nodeId
]

{ #category : #accessing }
TLVisualizationAddNodeCommand >> virtualNode [
	^ virtualNode
]

{ #category : #accessing }
TLVisualizationAddNodeCommand >> virtualNode: anObject [
	virtualNode := anObject
]
