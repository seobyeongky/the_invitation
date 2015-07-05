Server = IgeClass.extend

	classId : 'Server'

	Server : true

	init : (options) ->
		@players = []
		@tileData = []

		ige.timeScale 1

		@implement ServerNetworkEvents

		ige.addComponent(IgeNetIoComponent).network.start 2000, =>

			ige.start (success) =>
				if !success
					console.error 'start failed!'
					return

				ige.network.define 'gameTiles', (data,clientId,requestId) =>
					console.log('Client gameTiles command received from client id "' + clientId + '" with data:', data)
					ige.network.response(requestId, @tileData);

				ige.network.define 'playerEntity', @_onPlayerEntity
				ige.network.define 'playerControlToTile', @_onPlayerControlToTile  

				ige.network.on 'connect', @_onPlayerConnect
				ige.network.on 'disconnect', @_onPlayerDisconnect

				ige.network.addComponent(IgeStreamComponent).stream.sendInterval(30).stream.start()

				ige.network.acceptConnections true

				@mainScene = new IgeScene2d()
				.id 'mainScene'

				@backgroundScene = new IgeScene2d()
				.id 'backgroundScene'
				.layer 0
				.mount @mainScene

				@foregroundScene = new IgeScene2d()
				.id 'foregroundScene'
				.layer 1
				.mount @mainScene

				@vp1 = new IgeViewport()
				.id 'vp1'
				.autoSize true
				.scene @mainScene
				.drawBounds true
				.mount ige

				@collisionMap = new IgeTileMap2d()
				.tileWidth 40
				.tileHeight 40
				.translateTo 0, 0, 0

				for x in [0...20]
					for y in [0...20]
						rnd = Math.ceil(Math.random() * 4)
						@tileData[x] ?= []
						@tileData[x][y] = [0, rnd]

				@pathFinder = new IgePathFinder()
				.neighbourLimit 100


module.exports = Server if typeof module != 'undefined' and typeof module.exports != 'undefined'