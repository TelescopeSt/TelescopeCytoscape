"
I am a command sent at the end of the management of an action. This makes it possible to inform the client that the server has fully processed the order if the action generates regular sent of the component commands. 
"
Class {
	#name : #TLEndCommand,
	#superclass : #TLVisualizationServerCommand,
	#instVars : [
		'commanduid'
	],
	#category : #'Telescope-Cytoscape-Commands'
}

{ #category : #command }
TLEndCommand class >> command [
	^ 'endCommand'
]

{ #category : #accessing }
TLEndCommand class >> commanduid: aString [
	^ self new
		commanduid: aString;
		yourself
]

{ #category : #accessing }
TLEndCommand >> commanduid [
	^ commanduid
]

{ #category : #accessing }
TLEndCommand >> commanduid: anObject [
	commanduid := anObject
]
