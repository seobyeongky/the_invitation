module.exports = IgeEntity.extend
  classId: 'CharacterContainer'
  init: ->
    self = this
    IgeEntity::init.call this
    if !ige.isServer
      # Setup the entity 3d bounds
      self.size3d 20, 20, 40
      # Create a character entity as a child of this container
      self.character = (new Character).id(self.id() + '_character').setType(3).drawBounds(false).drawBoundsData(false).originTo(0.5, 0.6, 0.5).mount(self)
      # Set the co-ordinate system as isometric
      @isometric true
    if ige.isServer
      @addComponent IgePathComponent
    # Define the data sections that will be included in the stream
    @streamSections [
      'transform'
      'direction'
    ]
    return
  streamSectionData: (sectionId, data) ->
    # Check if the section is one that we are handling
    if sectionId == 'direction'
      # Check if the server sent us data, if not we are supposed
      # to return the data instead of set it
      if !ige.isServer
        if data
          # We have been given new data!
          @_streamDir = data
        else
          @_streamDir = 'stop'
      else
        # Return current data
        return @_streamDir
    else
      # The section was not one that we handle here, so pass this
      # to the super-class streamSectionData() method - it handles
      # the "transform" section by itself
      return IgeEntity::streamSectionData.call(this, sectionId, data)
    return
  update: (ctx) ->
    if ige.isServer
      # Make sure the character is animating in the correct
      # direction - this variable is actually streamed to the client
      # when it's value changes!
      @_streamDir = @path.currentDirection()
    else
      # Set the depth to the y co-ordinate which basically
      # makes the entity appear further in the foreground
      # the closer they become to the bottom of the screen
      @depth @_translate.y
      if @_streamDir
        if @_streamDir != @_currentDir or !@character.animation.playing()
          @_currentDir = @_streamDir
          dir = @_streamDir
          # The characters we are using only have four directions
          # so convert the NW, SE, NE, SW to N, S, E, W
          switch @_streamDir
            when 'S'
              dir = 'W'
            when 'E'
              dir = 'E'
            when 'N'
              dir = 'E'
            when 'W'
              dir = 'W'
          if dir and dir != 'stop'
            @character.animation.start dir
          else
            @character.animation.stop()
      else
        @character.animation.stop()
    IgeEntity::update.call this, ctx
    return