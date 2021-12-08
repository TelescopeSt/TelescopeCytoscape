Class {
	#name : #TLExternalTriggerCommand,
	#superclass : #TLVisualizationClientsCommand,
	#instVars : [
		'triggerId'
	],
	#category : #'Telescope-Cytoscape-Commands'
}

{ #category : #'instance creation' }
TLExternalTriggerCommand class >> newWithParameters: aParametersDictionary [
	^ (super newWithParameters: aParametersDictionary)
		triggerId: (aParametersDictionary at: #triggerId);
		yourself
]

{ #category : #execution }
TLExternalTriggerCommand >> executeOnVisu: aTLVisualization [
	aTLVisualization generator executeExternalTrigger: self triggerId .
]

{ #category : #accessing }
TLExternalTriggerCommand >> triggerId [
	^ triggerId
]

{ #category : #accessing }
TLExternalTriggerCommand >> triggerId: anID [
	triggerId := anID
]
