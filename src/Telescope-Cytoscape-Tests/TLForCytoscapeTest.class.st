Class {
	#name : #TLForCytoscapeTest,
	#superclass : #TestCase,
	#category : #'Telescope-Cytoscape-Tests-Model'
}

{ #category : #tests }
TLForCytoscapeTest >> testForCytoscapeColor [
	| rgbaMap |
	rgbaMap := Dictionary new
		at: #red put: 'rgba(244,67,54,1)';
		at: #pink put: 'rgba(233,30,99,1)';
		at: #purple put: 'rgba(156,39,176,1)';
		at: #deep_purple put: 'rgba(103,58,183,1)';
		at: #indigo put: 'rgba(63,81,181,1)';
		at: #blue put: 'rgba(33,150,243,1)';
		at: #light_blue put: 'rgba(3,169,244,1)';
		at: #cyan put: 'rgba(0,188,212,1)';
		at: #teal put: 'rgba(0,150,136,1)';
		at: #green put: 'rgba(76,175,80,1)';
		at: #light_green put: 'rgba(139,195,74,1)';
		at: #lime put: 'rgba(205,220,57,1)';
		at: #yellow put: 'rgba(255,235,59,1)';
		at: #amber put: 'rgba(255,193,7,1)';
		at: #orange put: 'rgba(255,152,0,1)';
		at: #deep_orange put: 'rgba(255,87,34,1)';
		at: #brown put: 'rgba(121,85,72,1)';
		at: #grey put: 'rgba(158,158,158,1)';
		at: #blue_grey put: 'rgba(96,125,139,1)';
		yourself.
	rgbaMap keysAndValuesDo: [ :tint :rgba | self assert: (MDLColor tint: tint) forCytoscape equals: rgba ]
]

{ #category : #tests }
TLForCytoscapeTest >> testForCytoscapeNumber [
	self assert: 1 forCytoscape equals: '1'.
	self assert: 1.5 forCytoscape equals: '1.5'.
	self assert: (22 / 4) forCytoscape equals: '5.5'
]

{ #category : #tests }
TLForCytoscapeTest >> testForCytoscapeString [
	self assert: 'test' forCytoscape equals: 'test'
]
