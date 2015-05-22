demos
exampleButterflyUsingStyleFunctionnality
	"self exampleButterflyUsingStyleFunctionnality"

	| butterfly |
	butterfly := TLButterfly new
		mainEntity: 10;
		leftEntities: [ :n | 1 to: n - 1 ];
		rightEntities: (15 to: 20).
	butterfly styleSheet shape: TLEllipseShape; width: 40.
	butterfly styleSheet > #redBackground backgroundColor: Color red.
	butterfly > #left addStyle: #redBackground.
	butterfly open.
	^ butterfly