as yet unclassified
nodesForEntities: aCollectionOfEntities
	^ self flatCollect: [ :aTelescopeEntity | aTelescopeEntity nodesForEntities: aCollectionOfEntities ]