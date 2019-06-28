Class {
	#name : #TLAcknowledgeReceiptCommand,
	#superclass : #TLVisualizationServerCommand,
	#category : 'Telescope-Cytoscape-Commands'
}

{ #category : #command }
TLAcknowledgeReceiptCommand class >> command [
	^ #acknoledgeReceipt
]

{ #category : #action }
TLAcknowledgeReceiptCommand >> sendCommandOn: aWebSocket [
   aWebSocket
				sendMessage:
					(NeoJSONWriter toString: {{ #command -> 'acknoledgeReceipt' . #visuId -> self visuId } asDictionary})
]
