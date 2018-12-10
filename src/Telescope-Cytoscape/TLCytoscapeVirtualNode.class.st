"
I am the virtual node specialised for cytoscape
"
Class {
	#name : #TLCytoscapeVirtualNode,
	#superclass : #TLVirtualNode,
	#instVars : [
		'nodeId'
	],
	#category : #'Telescope-Cytoscape-Virtuals'
}

{ #category : #accessing }
TLCytoscapeVirtualNode >> cytoscapePosition [
	"Cytoscape require the center of the node and Telescope works with center too"
	^ self absolutePosition
]

{ #category : #accessing }
TLCytoscapeVirtualNode >> dimensionChangedHook [
	"In cytoscape we need to update the dimensions via the connector, so we signal it and the connector will catch it."
	
	TLNodeDimensionChanged signalForNode: self tlNode
]

{ #category : #accessing }
TLCytoscapeVirtualNode >> id [
	^ self nodeId
]

{ #category : #accessing }
TLCytoscapeVirtualNode >> nodeId [
	^ nodeId
]

{ #category : #accessing }
TLCytoscapeVirtualNode >> nodeId: anObject [
	nodeId := anObject
]