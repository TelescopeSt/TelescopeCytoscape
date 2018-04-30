"
I am a baseline of thy Cytoscape connector for Telescope. Read more at: https://github.com/TelescopeSt/Telescope-Cytoscape
"
Class {
	#name : #BaselineOfTelescopeCytoscape,
	#superclass : #BaselineOf,
	#category : #BaselineOfTelescopeCytoscape
}

{ #category : #baselines }
BaselineOfTelescopeCytoscape >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"Dependencies"
			self
				neoJSON: spec;
				seaside3: spec;
				webSocket: spec;
				telescope: spec;
				materialDesignLite: spec.

			"Packages"
			spec
				package: 'Telescope-Cytoscape-Libraries' with: [ spec requires: #('Seaside3') ];
				package: 'Telescope-Cytoscape' with: [ spec requires: #('Telescope' 'WebSocket' 'Telescope-Cytoscape-Libraries' 'NeoJSON') ];
				package: 'Telescope-Demo-Cytoscape' with: [ spec requires: #('Telescope-Cytoscape' 'MaterialDesignLite') ];
				package: 'Telescope-Cytoscape-Tests' with: [ spec requires: #('Telescope-Cytoscape') ].

			"Groups"
			spec
				group: 'all' with: #('default');
				group: 'core' with: #('Telescope-Cytoscape');
				group: 'default' with: #('core' 'tests' 'demo');
				group: 'demo' with: #('Telescope-Demo-Cytoscape');
				group: 'tests' with: #('Telescope-Cytoscape-Tests') ]
]

{ #category : #dependencies }
BaselineOfTelescopeCytoscape >> materialDesignLite: spec [
	spec baseline: 'MaterialDesignLite' with: [ spec repository: 'github://DuneSt/MaterialDesignLite:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfTelescopeCytoscape >> neoJSON: spec [
	spec
		project: 'NeoJSON'
		with: [ spec
				className: #ConfigurationOfNeoJSON;
				versionString: #stable;
				repository: 'http://smalltalkhub.com/mc/SvenVanCaekenberghe/Neo/main' ]
]

{ #category : #accessing }
BaselineOfTelescopeCytoscape >> projectClass [
	^ [ self class environment at: #MetacelloCypressBaselineProject ]
		on: NotFound
		do: [ super projectClass ]
]

{ #category : #dependencies }
BaselineOfTelescopeCytoscape >> seaside3: spec [
	spec
		baseline: 'Seaside3'
		with: [ spec repository: 'github://SeasideSt/Seaside/repository' ]
]

{ #category : #dependencies }
BaselineOfTelescopeCytoscape >> telescope: spec [
	self flag: #todo.	"Whe Telescope will be released, use semantic versionning."
	spec baseline: 'Telescope' with: [ spec repository: 'github://TelescopeSt/Telescope:development/src' ]
]

{ #category : #dependencies }
BaselineOfTelescopeCytoscape >> webSocket: spec [
	spec
		project: 'WebSocket'
		with: [ spec
				className: 'ConfigurationOfZincHTTPComponents';
				version: #stable;
				loads: #('WebSocket');
				repository: 'http://mc.stfx.eu/ZincHTTPComponents' ]
]
