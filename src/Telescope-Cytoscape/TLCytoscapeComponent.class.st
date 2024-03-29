"
I am a seaside component that is able to render a telescope visualisation (TLVisualization)
"
Class {
	#name : #TLCytoscapeComponent,
	#superclass : #WAComponent,
	#instVars : [
		'visualization',
		'connector',
		'visuDivId',
		'waitingMessage',
		'style',
		'exportStrategy',
		'panzoom'
	],
	#classInstVars : [
		'lastId'
	],
	#category : #'Telescope-Cytoscape'
}

{ #category : #initialization }
TLCytoscapeComponent class >> initialize [
	lastId := 0
]

{ #category : #accessing }
TLCytoscapeComponent class >> lastId [
	^ lastId
]

{ #category : #accessing }
TLCytoscapeComponent class >> nextId [
	^ (lastId := self lastId + 1) asString
]

{ #category : #'instance creation' }
TLCytoscapeComponent class >> visualization: aTLVisualization [
	^ self new
		visualization: aTLVisualization;
		yourself
]

{ #category : #'instance creation' }
TLCytoscapeComponent class >> visualization: aTLVisualization id: anDivId [
	^ self new
		visualization: aTLVisualization;
		visuDivId: anDivId;
		yourself
]

{ #category : #accessing }
TLCytoscapeComponent >> connector [
	^ connector
]

{ #category : #accessing }
TLCytoscapeComponent >> connector: anObject [
	connector := anObject
]

{ #category : #exports }
TLCytoscapeComponent >> defaultJSONExport [
	self exportStrategy: TLCytoscapeJSONExportStrategy new
]

{ #category : #exports }
TLCytoscapeComponent >> defaultJpgExport [
	self
		exportStrategy:
			(TLCytoscapePngExportStrategy new
				scale: 5;
				quality: 1;
				yourself)
]

{ #category : #exports }
TLCytoscapeComponent >> defaultPngExport [
	self
		exportStrategy:
			(TLCytoscapePngExportStrategy new
				scale: 5;
				yourself)
]

{ #category : #accessing }
TLCytoscapeComponent >> defaultWaitingHtml [
	^ [ :html | 
	html div
		class: 'tlWaiting';
		with: [ 
					html image
						style: 'height: 50px; width: 50px;';
						url: (CYSFileLibrary urlOf: 'cog.gif').
					html heading
						level1;
						with: 'Please wait, loading in progress' ];
		yourself ]
]

{ #category : #accessing }
TLCytoscapeComponent >> exportStrategy [
	^ exportStrategy
]

{ #category : #accessing }
TLCytoscapeComponent >> exportStrategy: anObject [
	exportStrategy := anObject
]

{ #category : #initialization }
TLCytoscapeComponent >> initialize [
	super initialize.
	self exportStrategy: TLCytoscapeNullExportStrategy new
]

{ #category : #accessing }
TLCytoscapeComponent >> panzoom [
	^ panzoom ifNil: [ false ]
]

{ #category : #accessing }
TLCytoscapeComponent >> panzoom: anObject [
	panzoom := anObject
]

{ #category : #rendering }
TLCytoscapeComponent >> renderContentOn: html [

	| visuId div callback |
	visuId := self visuDivId.
	div := html div
		       id: visuId;
		       style: self style;
		       attributeAt: #isTelescopeVisu put: 'true';
		       attributeAt: #'data-port' put: self webSocketPort;
		       attributeAt: #'data-panzoom' put: self panzoom asString;
		       class: 'telescopeVisu';
		       with: [ 
			       html div
				       class: 'visualization';
				       style: 'height: 100%; width: 100%;';
				       with: [ 
					       html div
						       id: #fetching;
						       with: [ self renderFetchingDivOn: html ] ].
			       self waitingMessage value: html.
			       self renderOptionalButtonsOn: html ];
		       yourself.
	callback := WAValueCallback new.
	TLCytoscapeWebSocketDelegate
		registerVisualization: self visualization
		underId: visuId
		withCallBack: callback
		callbackUrl: { 
				html actionUrl asString.
				(div storeCallback: callback) }
]

{ #category : #rendering }
TLCytoscapeComponent >> renderFetchingDivOn: html [

	html text: 'Fetching'
]

{ #category : #rendering }
TLCytoscapeComponent >> renderOptionalButtonsOn: html [
	html div
		class: 'fitButton';
		with: [ self renderResetButtonOn: html.
			self exportStrategy renderDownloadButtonForVisu: self visuDivId on: html ]
]

{ #category : #rendering }
TLCytoscapeComponent >> renderResetButtonOn: html [
	html anchor
		onClick: 'telescope.visuWithId(' , self visuDivId asString , ').fit();';
		with: 'Reset'
]

{ #category : #accessing }
TLCytoscapeComponent >> style [
	^ style
]

{ #category : #accessing }
TLCytoscapeComponent >> style: anObject [
	style := anObject
]

{ #category : #accessing }
TLCytoscapeComponent >> visuDivId [
	visuDivId ifNil: [ visuDivId:= self class nextId ].
	^ visuDivId
]

{ #category : #accessing }
TLCytoscapeComponent >> visuDivId: anObject [
	visuDivId := anObject
]

{ #category : #accessing }
TLCytoscapeComponent >> visualization [
	^ visualization
]

{ #category : #accessing }
TLCytoscapeComponent >> visualization: anObject [
	visualization := anObject.
	connector := TLCytoscapeConnector new.
	visualization generator: connector
]

{ #category : #accessing }
TLCytoscapeComponent >> waitingMessage [
	^ waitingMessage ifNil: [ self defaultWaitingHtml ]
]

{ #category : #accessing }
TLCytoscapeComponent >> waitingMessage: anObject [
	waitingMessage := anObject
]

{ #category : #accessing }
TLCytoscapeComponent >> webSocketPort [
	^ TLCytoscapeWebSocketDelegate clientPort
]
