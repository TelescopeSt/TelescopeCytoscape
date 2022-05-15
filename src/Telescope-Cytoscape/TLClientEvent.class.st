"
I am here to ensure event's name used by client side interactions. 
"
Class {
	#name : #TLClientEvent,
	#superclass : #Object,
	#category : #'Telescope-Cytoscape-Connector'
}

{ #category : #sugar }
TLClientEvent class >> mouseClick [
	^ #mouseclick
]

{ #category : #sugar }
TLClientEvent class >> mouseDbClick [
	^ #mousedbclick
]

{ #category : #sugar }
TLClientEvent class >> mouseDown [
	^ #mousedown
]

{ #category : #sugar }
TLClientEvent class >> mouseEnter [
	^ #mouseenter
]

{ #category : #sugar }
TLClientEvent class >> mouseLeave [
	^ #mouseleave
]

{ #category : #sugar }
TLClientEvent class >> mouseOut [
	^ #mouseout
]

{ #category : #sugar }
TLClientEvent class >> mouseOver [
	^ #mouseover
]

{ #category : #sugar }
TLClientEvent class >> mouseUp [
	^ #mouseup
]
