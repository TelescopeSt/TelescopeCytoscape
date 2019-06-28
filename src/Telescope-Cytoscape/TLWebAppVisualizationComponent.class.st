"
I'm a seaside component used to render a TLVisualization.
I'm used to render any kind of visualization defined by an end user. 

I am registered as 'UserVisualization' .
I use a TLWebAppVisualization to know the visualization I have to render.

I'm used to render a TLVisualization through the method openOnWeb.
"
Class {
	#name : #TLWebAppVisualizationComponent,
	#superclass : #WAComponent,
	#instVars : [
		'webAppVisualization'
	],
	#category : 'Telescope-Cytoscape'
}

{ #category : #initialization }
TLWebAppVisualizationComponent class >> ensureIsRunning [
	(WAAdmin isAnAppRegisteredAt: 'UserVisualisation')
		ifFalse:[self initialize]
]

{ #category : #'class initialization' }
TLWebAppVisualizationComponent class >> initialize [
	self initializeAt: 'UserVisualization'
]

{ #category : #initialization }
TLWebAppVisualizationComponent class >> initializeAt: aString [
	| app |
	app := WAAdmin register: self asApplicationAt: aString.
	
	app
		addLibrary: JQDeploymentLibrary;
		addLibrary: CYSFileLibrary.
]

{ #category : #initialization }
TLWebAppVisualizationComponent >> initialize [
	super initialize.
	webAppVisualization := TLWebAppVisualization singleton.
]

{ #category : #rendering }
TLWebAppVisualizationComponent >> renderContentOn: html [
	| component |
	component := TLCytoscapeComponent visualization: webAppVisualization visualization.
	html text: 'See all demo in ',  TLCytoscapeTelescopeDemoComponent demoName , ' application'.
	html render: (component style: 'height: 100%; width:100%;').
]

{ #category : #hooks }
TLWebAppVisualizationComponent >> style [
	^ 'body, html{
	height: 100%;
	width: 100%;
}'
]

{ #category : #rendering }
TLWebAppVisualizationComponent >> updateRoot: anHtmlRoot [
self flag:'Il faudrait voir comment on peut changer facilement le titre de l onglet qui sera ouvert'.
	super updateRoot: anHtmlRoot.
	anHtmlRoot beHtml5.
	anHtmlRoot title: 'User Visualization' .
	anHtmlRoot stylesheet
		url: (WAUrl absolute: 'https://storage.googleapis.com/code.getmdl.io/1.0.0/material.indigo-pink.min.css').
	anHtmlRoot script url: (WAUrl absolute: 'https://storage.googleapis.com/code.getmdl.io/1.0.0/material.min.js').
	
	anHtmlRoot stylesheet url: (WAUrl absolute: 'https://fonts.googleapis.com/icon?family=Material+Icons')
]
