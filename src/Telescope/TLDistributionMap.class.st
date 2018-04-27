"
A TLDistributionMap is a visualization where the user specify a collection of container entities, how to get inner elements and a property to apply on those elements. It will create a map with big boxes for container; with small boxes (one for each inner entity) colored depending on the property.

Containers are put in the containers group (self > #containers)

Instance Variables
	colorToProperty:		<Object>
	containerEntities:		<Object>
	innerEntities:		<Object>
	property:		<Object>

colorToProperty
	- xxxxx

containerEntities
	- xxxxx

innerEntities
	- xxxxx

property
	- xxxxx

"
Class {
	#name : #TLDistributionMap,
	#superclass : #TLVisualization,
	#instVars : [
		'containerEntities',
		'innerEntities',
		'property',
		'colorToProperty',
		'innerEntitiesPopupBlock'
	],
	#category : 'Telescope-Visualizations'
}

{ #category : #creation }
TLDistributionMap class >> containerEntities: aCollectionOfEntities innerEntities: innerEntitiesPropertyOrBlock property: legendProperty [
	^ self new
		containerEntities: aCollectionOfEntities;
		innerEntities: innerEntitiesPropertyOrBlock;
		property: legendProperty
]

{ #category : #building }
TLDistributionMap >> buildLegend [
	super buildLegend.
	self legend backgroundDescription: [ :entity | (property cull: entity) asString ] forNodes: (self > #containers) allChildrenNodes
]

{ #category : #building }
TLDistributionMap >> buildVisualization [
	self > #containers nodeBackgroundColor: Color white.
	self > #containers nodeChildrenProperty: self innerEntities.
	(self > #containers) styleSheet > #children backgroundColor: self createColorBlock.
	(self > #containers) styleSheet nodeLabel: #asString position: #top.
	((self > #containers) styleSheet > #children) noNodeLabel.
	self > #containers addNodesFromEntities: self containerEntities.
	(self > #containers) allChildrenNodes addInteraction: (TLPopUpAction text: [ :entity | self obtain: self innerEntitiesPopupBlock on: entity ]) onMouseOver.
	(self addInteraction: TLExpandCollapseCompositeNodeAction onCompositeNodeWithChildren onClick) propagateToChildren.
	super buildVisualization
]

{ #category : #accessing }
TLDistributionMap >> colorToProperty [
	^ colorToProperty
]

{ #category : #accessing }
TLDistributionMap >> colorToProperty: anObject [
	colorToProperty := anObject
]

{ #category : #layout }
TLDistributionMap >> configLayout [
	self > #containers layout: (TLLinearLayout gap: 20 ratio: 16/9)
]

{ #category : #accessing }
TLDistributionMap >> containerEntities [
	^ containerEntities
]

{ #category : #accessing }
TLDistributionMap >> containerEntities: aCollectionOfObjects [
	containerEntities := aCollectionOfObjects
]

{ #category : #private }
TLDistributionMap >> createColorBlock [
	| frequencyDictionary sortedProperties |
	frequencyDictionary := Dictionary new.
	(self containerEntities flatCollect: self innerEntities)
		do: [ :anEntity | 
			frequencyDictionary
				at: (self property value: anEntity)
				put: (frequencyDictionary at: (self property value: anEntity) ifAbsent: [ 0 ]) + 1 ].
	sortedProperties := (frequencyDictionary associations sort: [ :a :b | a value > b value ]) collect: #key.
	self colorToProperty: ((self defaultColors first: (sortedProperties size min: self defaultColors size))
		collectWithIndex: [ :aColor :anIndex | (sortedProperties at: anIndex) -> aColor ]) asDictionary.
	^ [ :anEntity | 
	| color |
	color := self colorToProperty at: (self property value: anEntity) ifAbsent: [ self defaultColor ].
	color ]
]

{ #category : #default }
TLDistributionMap >> defaultColor [
	^ Color gray
]

{ #category : #default }
TLDistributionMap >> defaultColors [
	^ MDLColor colors keys
		inject: OrderedCollection new
		into: [ :coll :color | 
			coll
				add: (MDLColor tint: color code: #'200');
				add: (MDLColor tint: color code: #'800');
				yourself ]
]

{ #category : #default }
TLDistributionMap >> defaultTitle [
	^ 'Distribution Map'
]

{ #category : #initialization }
TLDistributionMap >> initialize [
	super initialize.
	self styleSheet compositeExpandedByDefault: true
]

{ #category : #accessing }
TLDistributionMap >> innerEntities [
	^ innerEntities
]

{ #category : #accessing }
TLDistributionMap >> innerEntities: anObject [
	innerEntities := anObject
]

{ #category : #accessing }
TLDistributionMap >> innerEntitiesPopupBlock [
	^ innerEntitiesPopupBlock ifNil: [ innerEntitiesPopupBlock := #asString ]
]

{ #category : #accessing }
TLDistributionMap >> innerEntitiesPopupBlock: anObject [
	innerEntitiesPopupBlock := anObject
]

{ #category : #accessing }
TLDistributionMap >> property [
	^ property
]

{ #category : #accessing }
TLDistributionMap >> property: anObject [
	property := anObject
]