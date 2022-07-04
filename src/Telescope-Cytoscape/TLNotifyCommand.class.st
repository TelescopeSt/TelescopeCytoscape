Class {
	#name : #TLNotifyCommand,
	#superclass : #TLVisualizationServerCommand,
	#instVars : [
		'message'
	],
	#category : #'Telescope-Cytoscape-Commands'
}

{ #category : #command }
TLNotifyCommand class >> command [

	^ #notify
]

{ #category : #accessing }
TLNotifyCommand class >> message: aString [

	^ self new
		  message: aString;
		  yourself
]

{ #category : #accessing }
TLNotifyCommand >> message [
	^ message
]

{ #category : #accessing }
TLNotifyCommand >> message: anObject [

	message := anObject
]
