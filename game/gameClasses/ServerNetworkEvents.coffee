module.exports = (global ? window).ServerNetworkEvents =

	_onPlayerConnect : (sock) ->
		false

	_onPlayerDisconnect : (clientId) ->
		ref = ige.server.players[clientId]
		if ref?
			ref.destroy()
			delete ige.server.players[clientId]

	_onPlayerEntity : (data,clientId) ->
		unless ige.server.players[clientId]?
			ige.server.players[clientId] = new CharacterContainer(clientId)
			.addComponent PlayerComponent
			.streamMode 1
			.mount ige.server.foregroundMap

			ige.network.send 'playerEntity', ige.server.players[clientId].id(), clientId

	_onPlayerControlToTile : (data,clientId) ->
		playerEntity = ige.server.players[clientId]
		throw new Error("no playerEntity!!") unless playerEntity?

		startTile = playerEntity._parent.pointToTile currentPosition.toIso()
		dest = new IgePoint(parseInt(data[0]), parseInt(data[1]), 0)
		newPath = ige.server.pathFinder.aStar ige.server.collisionMap, startTile, dest, (tileData,tileX,tileY) ->
			tileData != 1
		, true, false

		playerEntity
		.path.clear()
		.path.add newPath
		.path.start()

