module.exports =

	_onPlayerEntity: (data) ->
		if ige.$(data)
			# Add the player control component
			ige.$(data).addComponent PlayerComponent
			# Track our player with the camera
			ige.client.vp1.camera.trackTranslate ige.$(data), 50
		else
			# The client has not yet received the entity via the network
			# stream so lets ask the stream to tell us when it creates a
			# new entity and then check if that entity is the one we
			# should be tracking!
			self = this
			self._eventListener = ige.network.stream.on 'entityCreated', (entity) ->
				if entity.id() == data
					# Add the player control component
					ige.$(data).addComponent PlayerComponent
					# Tell the camera to track out player entity
					ige.client.vp1.camera.trackTranslate ige.$(data), 50
					# Turn off the listener for this event now that we
					# have found and started tracking our player entity
					ige.network.stream.off 'entityCreated', self._eventListener, (result) ->
						if !result
							@log 'Could not disable event listener!', 'warning'
