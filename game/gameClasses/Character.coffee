module.exports = (global ? window).Character = IgeEntity.extend

  classId: 'Character'

  init: ->
    self = this
    IgeEntity::init.call this
    if !ige.isServer
      # Setup the entity
      self.addComponent(IgeAnimationComponent).depth 1
      # Load the character texture file
      @_characterTexture = new IgeCellSheet('../assets/textures/sprites/vx_chara02_c.png', 12, 8)
      # Wait for the texture to load
      @_characterTexture.on 'loaded', (->
        self.texture(self._characterTexture).dimensionsFromCell()
        self.setType 0
        return
      ), false, true
    @_lastTranslate = @_translate.clone()
    # Was debugging so setting a trace - turned off now, found bug in path component
    # under specific conditions
    #ige.traceSet(this._translate, 'x', 5);
    return

  setType: (type) ->
    switch type
      when 0
        @animation.define('S', [
          1
          2
          3
          2
        ], 8, -1).animation.define('W', [
          13
          14
          15
          14
        ], 8, -1).animation.define('E', [
          25
          26
          27
          26
        ], 8, -1).animation.define('N', [
          37
          38
          39
          38
        ], 8, -1).cell 1
        @_restCell = 1
      when 1
        @animation.define('S', [
          4
          5
          6
          5
        ], 8, -1).animation.define('W', [
          16
          17
          18
          17
        ], 8, -1).animation.define('E', [
          28
          29
          30
          29
        ], 8, -1).animation.define('N', [
          40
          41
          42
          41
        ], 8, -1).cell 4
        @_restCell = 4
      when 2
        @animation.define('S', [
          7
          8
          9
          8
        ], 8, -1).animation.define('W', [
          19
          20
          21
          20
        ], 8, -1).animation.define('E', [
          31
          32
          33
          32
        ], 8, -1).animation.define('N', [
          43
          44
          45
          44
        ], 8, -1).cell 7
        @_restCell = 7
      when 3
        @animation.define('S', [
          10
          11
          12
          11
        ], 8, -1).animation.define('W', [
          22
          23
          24
          23
        ], 8, -1).animation.define('E', [
          34
          35
          36
          35
        ], 8, -1).animation.define('N', [
          46
          47
          48
          47
        ], 8, -1).cell 10
        @_restCell = 10
      when 4
        @animation.define('S', [
          49
          50
          51
          50
        ], 8, -1).animation.define('W', [
          61
          62
          63
          62
        ], 8, -1).animation.define('E', [
          73
          74
          75
          74
        ], 8, -1).animation.define('N', [
          85
          86
          87
          86
        ], 8, -1).cell 49
        @_restCell = 49
      when 5
        @animation.define('S', [
          52
          53
          54
          53
        ], 8, -1).animation.define('W', [
          64
          65
          66
          65
        ], 8, -1).animation.define('E', [
          76
          77
          78
          77
        ], 8, -1).animation.define('N', [
          88
          89
          90
          89
        ], 8, -1).cell 52
        @_restCell = 52
      when 6
        @animation.define('S', [
          55
          56
          57
          56
        ], 8, -1).animation.define('W', [
          67
          68
          69
          68
        ], 8, -1).animation.define('E', [
          79
          80
          81
          80
        ], 8, -1).animation.define('N', [
          91
          92
          93
          92
        ], 8, -1).cell 55
        @_restCell = 55
      when 7
        @animation.define('S', [
          58
          59
          60
          59
        ], 8, -1).animation.define('W', [
          70
          71
          72
          71
        ], 8, -1).animation.define('E', [
          82
          83
          84
          83
        ], 8, -1).animation.define('N', [
          94
          95
          96
          95
        ], 8, -1).cell 58
        @_restCell = 58
    this
    
  destroy: ->
    # Destroy the texture object
    if @_characterTexture
      @_characterTexture.destroy()
    # Call the super class
    IgeEntity::destroy.call this