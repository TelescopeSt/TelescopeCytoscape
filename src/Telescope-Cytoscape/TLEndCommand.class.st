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
