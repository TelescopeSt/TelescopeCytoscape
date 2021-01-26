Class {
	#name : #TLVisualizationCommandTest,
	#superclass : #TestCase,
	#category : #'Telescope-Cytoscape-Tests-Commands'
}

{ #category : #tests }
TLVisualizationCommandTest >> testTLVisualizationAddEdgeCommand [
	| command json |
	command := TLVisualizationAddEdgeCommand new
		edgeId: '5';
		fromNodeId: 'sourceNode';
		toNodeId: 'targetNode';
		mouseOverInteraction: true;
		menu: {  };
		yourself.
	json := NeoJSONWriter toString: command.
	#('"mouseOverInteraction":true' '"data":{' '"target":"targetNode"' '"id":"5"' '"source":"sourceNode"' '"group":"edges"') do: [ :jsonPart | self assert: (json includesSubstring: jsonPart) ]
]
