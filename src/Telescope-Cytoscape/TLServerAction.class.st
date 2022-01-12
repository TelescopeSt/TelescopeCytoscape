Class {
	#name : #TLServerAction,
	#superclass : #TLDrawableAction,
	#instVars : [
		'block'
	],
	#category : #'Telescope-Cytoscape-Actions'
}

{ #category : #accessing }
TLServerAction >> actionOn: aTLDrawable [
	| commandId generator visu |
	commandId := UUIDGenerator next asString .
	generator:= aTLDrawable generator.
	visu := aTLDrawable visualization.
	generator startServerCommandWith: commandId.
	TLCytoscapeWebSocketDelegate singleton
		sendCommands: generator removeAllCommands
		forVisu: visu.
	self block cull: aTLDrawable.
	aTLDrawable generator sendEndCommandFor: commandId.
	TLCytoscapeWebSocketDelegate singleton
		sendCommands: generator removeAllCommands
		forVisu: visu.
]

{ #category : #accessing }
TLServerAction >> block [
	^ block
]

{ #category : #accessing }
TLServerAction >> block: anObject [
	block := anObject
]
