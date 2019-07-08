"
I am a virtual node used to compute positions on the server side when the display is done elsewhere. The goal is to apply layouts on me to then send the right positions to the client.

position is the same as rectangle: the upper left corner
"
Class {
	#name : #TLVirtualNode,
	#superclass : #Object,
	#traits : 'TVirtualElement',
	#classTraits : 'TVirtualElement classTrait',
	#instVars : [
		'position',
		'dimension',
		'nodeId',
		'parent',
		'children',
		'realNode',
		'compositeMargin',
		'encompassingRectangle',
		'userFixedPosition',
		'triggers'
	],
	#category : #'Telescope-Cytoscape-Virtual'
}

{ #category : #accessing }
TLVirtualNode >> absolutePosition [
	"A VirtualNode will always have a group as parent. We take the upper left position of the parent because the layouts will place nodes regarding on it."

	^ self hasParent
		ifTrue: [ self position + self parent upperLeftAbsolutePosition ]
		ifFalse: [ self position ]
]

{ #category : #accessing }
TLVirtualNode >> addChildren: aChildren [
	self children addChildren: aChildren
]

{ #category : #accessing }
TLVirtualNode >> addTrigger: aTLVirtualTrigger [
	triggers add: aTLVirtualTrigger.
	aTLVirtualTrigger virtualNodeReference: self.
]

{ #category : #position }
TLVirtualNode >> calculateRelativePositionFromAbsolute: aPosition [
	^ aPosition - (self hasParent ifTrue: [ parent upperLeftAbsolutePosition ] ifFalse: [ 0 @ 0 ])
]

{ #category : #accessing }
TLVirtualNode >> children [
	^ children
]

{ #category : #accessing }
TLVirtualNode >> children: anObject [
	children := anObject
]

{ #category : #optimization }
TLVirtualNode >> clearEncompassingRectangle [
	encompassingRectangle := nil
]

{ #category : #accessing }
TLVirtualNode >> compositeMargin [
	^ compositeMargin ifNil: [ 10@10 ]
]

{ #category : #accessing }
TLVirtualNode >> compositeMargin: anObject [
	compositeMargin := anObject
]

{ #category : #position }
TLVirtualNode >> cytoscapePosition [
	"Cytoscape require the center of the node and Telescope works with center too"
	^ self absolutePosition
]

{ #category : #position }
TLVirtualNode >> defineFixedPositionFromAbsolute: aPosition [
	self defineFixedRelativePosition: (self calculateRelativePositionFromAbsolute: aPosition)
]

{ #category : #accessing }
TLVirtualNode >> dimension [
	^ self hasChildren
		ifTrue: [ self children encompassingRectangle extent + (2 * self compositeMargin) ]
		ifFalse: [ dimension ]
]

{ #category : #accessing }
TLVirtualNode >> dimension: anObject [
	dimension := anObject.
	self clearEncompassingRectangle
]

{ #category : #accessing }
TLVirtualNode >> encompassingRectangle [
	^ encompassingRectangle ifNil: [ encompassingRectangle := Rectangle center: self position extent: self dimension ]
]

{ #category : #accessing }
TLVirtualNode >> extent [
	^ self dimension
]

{ #category : #accessing }
TLVirtualNode >> hasChildren [
	^ self children notEmpty 
]

{ #category : #accessing }
TLVirtualNode >> height [
	^ self dimension y
]

{ #category : #dimension }
TLVirtualNode >> height: anInteger [
	self dimension: self dimension x @ anInteger
]

{ #category : #accessing }
TLVirtualNode >> id [
	^ self nodeId
]

{ #category : #adjacent }
TLVirtualNode >> incomingAdjacentNodes [
	^ self realNode incomingAdjacentNodes
		collect: [ :node | 
			[ node generator elementFromTLDrawable: node ]
				on: NotFound
				do: [ node generate ] ]
]

{ #category : #accessing }
TLVirtualNode >> initialize [
	super initialize.
	self children: (TLVirtualGroup new composite: self).
	triggers:= OrderedCollection new 
]

{ #category : #testing }
TLVirtualNode >> isNode [
	^ true
]

{ #category : #accessing }
TLVirtualNode >> nodeId [
	^ nodeId
]

{ #category : #accessing }
TLVirtualNode >> nodeId: anObject [
	nodeId := anObject
]

{ #category : #dimension }
TLVirtualNode >> occupyMaxSpace [
	^ self realNode effectiveStyleSheet takeAllSpace
]

{ #category : #adjacent }
TLVirtualNode >> outgoingAdjacentNodes [
	^ self realNode outgoingAdjacentNodes
		collect: [ :node | 
			[ node generator elementFromTLDrawable: node ]
				on: NotFound
				do: [ node generate ] ]
]

{ #category : #accessing }
TLVirtualNode >> parent [
	^ parent
]

{ #category : #accessing }
TLVirtualNode >> parent: aParent [
	parent := aParent.
	aParent addChildren: self.
	
]

{ #category : #accessing }
TLVirtualNode >> position [
	^ position
]

{ #category : #accessing }
TLVirtualNode >> position: anObject [
	position := anObject.
	self clearEncompassingRectangle
]

{ #category : #printing }
TLVirtualNode >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< (self realNode ifNotNil: [ :node | node entity asString ] ifNil: [ 'No real node associated yet' ]);
		<< $)
]

{ #category : #accessing }
TLVirtualNode >> realNode [
	^ realNode
]

{ #category : #accessing }
TLVirtualNode >> realNode: anObject [
	realNode := anObject
]

{ #category : #dimension }
TLVirtualNode >> restoreOriginalDimension [
	| styleSheet |
	styleSheet := self realNode effectiveStyleSheet.
	self
		dimension:
			(styleSheet obtainValue: #width forEntity: self realNode entity inNode: self realNode)
				@ (styleSheet obtainValue: #height forEntity: self realNode entity inNode: self realNode)
]

{ #category : #accessing }
TLVirtualNode >> triggers [
	^ triggers
]

{ #category : #accessing }
TLVirtualNode >> width [
	^ self dimension x
]

{ #category : #accessing }
TLVirtualNode >> x [
	^ self position x
]

{ #category : #accessing }
TLVirtualNode >> y [
	^ self position y
]
