module.exports = IgeEntity.extend

  classId: 'PlayerComponent'

  componentId: 'playerControl'

  init: (entity, options) ->
    self = this
    # Store the entity that this component has been added to
    @_entity = entity
    # Store any options that were passed to us
    @_options = options
    if !ige.isServer
      # Listen for mouse events on the texture map
      ige.client.textureMap1.mouseUp (tileX, tileY, event) ->
        # Send a message to the server asking to path to this tile
        ige.network.send 'playerControlToTile', [
          tileX
          tileY
        ]