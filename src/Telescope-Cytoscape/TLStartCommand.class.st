"
I must be send if command are send by server without client action.
For example, if a cron on server modify the visu, the client know it.
"
Class {
	#name : #TLStartCommand,
	#superclass : #TLVisualizationServerCommand,
	#instVars : [
		'commanduid'
	],
	#category : #'Telescope-Cytoscape-Commands'
}

{ #category : #command }
TLStartCommand class >> command [
	^ 'startCommand'
]

{ #category : #accessing }
TLStartCommand >> commanduid [
	^ commanduid
]

{ #category : #accessing }
TLStartCommand >> commanduid: anObject [
	commanduid := anObject
]
