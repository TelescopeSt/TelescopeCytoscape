Class {
	#name : #TLCytoscapeVirtualNode,
	#superclass : #TLVirtualNode,
	#instVars : [
		'nodeId'
	],
	#category : #'Telescope-Cytoscape-Virtuals'
}

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
