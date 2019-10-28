Class {
	#name : #TLCytoscapeConnectorTest,
	#superclass : #TestCase,
	#instVars : [
		'connector'
	],
	#category : #'Telescope-Cytoscape-Tests-Connector'
}

{ #category : #running }
TLCytoscapeConnectorTest >> setUp [
	super setUp.
	connector := TLCytoscapeConnector new
]

{ #category : #tests }
TLCytoscapeConnectorTest >> testGroupUpdating [
	| group |
	group := TLEntitiesGroup new.
	group
		nodeCreationStrategy: TLNodeCreationStrategy default;
		styleSheet: TLStyleSheet default.
	group addNodesFromEntities: (1 to: 5).
	group generator: connector.
	group generate.
	self assert: (connector elementFromTLDrawable: group) class equals: TLVirtualGroup.
	self assert: (connector elementFromTLDrawable: group) size equals: 5.
	group removeEntity: 3.
	connector updateGroup: group.	
	self assert: (connector elementFromTLDrawable: group) size equals: 4.
	
]

{ #category : #tests }
TLCytoscapeConnectorTest >> testGroupUpdatingAfterMoving [
	| groupA groupB node |
	groupA := TLEntitiesGroup new.
	groupA
		nodeCreationStrategy: TLNodeCreationStrategy default;
		styleSheet: TLStyleSheet default.
	groupB := TLEntitiesGroup new.
	groupB
		nodeCreationStrategy: TLNodeCreationStrategy default;
		styleSheet: TLStyleSheet default.
	node := groupA addNodeFromEntity: 1.
	groupA generator: connector.
	groupA generate.
	groupB generator: connector.
	groupB generate.
	self assert: (connector elementFromTLDrawable: node) parent equals: (connector elementFromTLDrawable: groupA).
	node moveToGroup: groupB.
	groupA update.
	groupB update.
	self assert: (connector elementFromTLDrawable: node) parent equals: (connector elementFromTLDrawable: groupB)
]

{ #category : #tests }
TLCytoscapeConnectorTest >> testLayoutApplicationOnComposite [
	| group mockLayout |
	group := TLEntitiesGroup new.
	mockLayout := Mock named: 'layout'.
	group
		nodeCreationStrategy: (TLNodeCreationStrategy composite: [:i | i to: i + 5] withLayout: mockLayout);
		styleSheet: (TLStyleSheet default compositeExpandedByDefault: true).
	group addNodeFromEntity: 1.
	group generator: connector.
	group generate.
	(mockLayout should receive on: Any) once
]

{ #category : #tests }
TLCytoscapeConnectorTest >> testLayoutApplicationOnCompositeIntoComposite [
	| group mockLayout childrenMockLayout |
	group := TLEntitiesGroup new.
	mockLayout := Mock named: 'layout'.
	childrenMockLayout := Mock named: 'childrenLayout'.
	group
		nodeCreationStrategy: (TLNodeCreationStrategy composite: [ :i | i to: i + 1 ] withLayout: mockLayout);
		styleSheet: (TLStyleSheet default compositeExpandedByDefault: true).
	group nodeCreationStrategy
		childrenStrategy: (TLNodeCreationStrategy composite: [ :i | i to: i + 5 ] withLayout: childrenMockLayout).
	group addNodeFromEntity: 1.
	group generator: connector.
	group generate.
	(mockLayout should receive on: Any) once.
	(childrenMockLayout should receive on: Any) twice
]
