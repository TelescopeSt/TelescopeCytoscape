"
I am the command sent by the client after the opening of the connection to ask for the generation of a visualization
"
Class {
	#name : #TLVisualizationGenerationCommand,
	#superclass : #TLVisualizationClientsCommand,
	#category : #'Telescope-Cytoscape-Commands'
}

{ #category : #execution }
TLVisualizationGenerationCommand >> executeOnVisu: aTLVisualization [ 
	aTLVisualization generate
]
