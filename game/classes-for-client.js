(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
require('./gameClasses/Character.coffee');

require('./gameClasses/CharacterContainer.coffee');

require('./gameClasses/ClientNetworkEvents.coffee');

require('./gameClasses/PlayerComponent.coffee');


},{"./gameClasses/Character.coffee":2,"./gameClasses/CharacterContainer.coffee":3,"./gameClasses/ClientNetworkEvents.coffee":4,"./gameClasses/PlayerComponent.coffee":5}],2:[function(require,module,exports){
module.exports = IgeEntity.extend({
  classId: 'Character',
  init: function() {
    var self;
    self = this;
    IgeEntity.prototype.init.call(this);
    if (!ige.isServer) {
      self.addComponent(IgeAnimationComponent).depth(1);
      this._characterTexture = new IgeCellSheet('../assets/textures/sprites/vx_chara02_c.png', 12, 8);
      this._characterTexture.on('loaded', (function() {
        self.texture(self._characterTexture).dimensionsFromCell();
        self.setType(0);
      }), false, true);
    }
    this._lastTranslate = this._translate.clone();
  },
  setType: function(type) {
    switch (type) {
      case 0:
        this.animation.define('S', [1, 2, 3, 2], 8, -1).animation.define('W', [13, 14, 15, 14], 8, -1).animation.define('E', [25, 26, 27, 26], 8, -1).animation.define('N', [37, 38, 39, 38], 8, -1).cell(1);
        this._restCell = 1;
        break;
      case 1:
        this.animation.define('S', [4, 5, 6, 5], 8, -1).animation.define('W', [16, 17, 18, 17], 8, -1).animation.define('E', [28, 29, 30, 29], 8, -1).animation.define('N', [40, 41, 42, 41], 8, -1).cell(4);
        this._restCell = 4;
        break;
      case 2:
        this.animation.define('S', [7, 8, 9, 8], 8, -1).animation.define('W', [19, 20, 21, 20], 8, -1).animation.define('E', [31, 32, 33, 32], 8, -1).animation.define('N', [43, 44, 45, 44], 8, -1).cell(7);
        this._restCell = 7;
        break;
      case 3:
        this.animation.define('S', [10, 11, 12, 11], 8, -1).animation.define('W', [22, 23, 24, 23], 8, -1).animation.define('E', [34, 35, 36, 35], 8, -1).animation.define('N', [46, 47, 48, 47], 8, -1).cell(10);
        this._restCell = 10;
        break;
      case 4:
        this.animation.define('S', [49, 50, 51, 50], 8, -1).animation.define('W', [61, 62, 63, 62], 8, -1).animation.define('E', [73, 74, 75, 74], 8, -1).animation.define('N', [85, 86, 87, 86], 8, -1).cell(49);
        this._restCell = 49;
        break;
      case 5:
        this.animation.define('S', [52, 53, 54, 53], 8, -1).animation.define('W', [64, 65, 66, 65], 8, -1).animation.define('E', [76, 77, 78, 77], 8, -1).animation.define('N', [88, 89, 90, 89], 8, -1).cell(52);
        this._restCell = 52;
        break;
      case 6:
        this.animation.define('S', [55, 56, 57, 56], 8, -1).animation.define('W', [67, 68, 69, 68], 8, -1).animation.define('E', [79, 80, 81, 80], 8, -1).animation.define('N', [91, 92, 93, 92], 8, -1).cell(55);
        this._restCell = 55;
        break;
      case 7:
        this.animation.define('S', [58, 59, 60, 59], 8, -1).animation.define('W', [70, 71, 72, 71], 8, -1).animation.define('E', [82, 83, 84, 83], 8, -1).animation.define('N', [94, 95, 96, 95], 8, -1).cell(58);
        this._restCell = 58;
    }
    return this;
  },
  destroy: function() {
    if (this._characterTexture) {
      this._characterTexture.destroy();
    }
    return IgeEntity.prototype.destroy.call(this);
  }
});


},{}],3:[function(require,module,exports){
module.exports = IgeEntity.extend({
  classId: 'CharacterContainer',
  init: function() {
    var self;
    self = this;
    IgeEntity.prototype.init.call(this);
    if (!ige.isServer) {
      self.size3d(20, 20, 40);
      self.character = (new Character).id(self.id() + '_character').setType(3).drawBounds(false).drawBoundsData(false).originTo(0.5, 0.6, 0.5).mount(self);
      this.isometric(true);
    }
    if (ige.isServer) {
      this.addComponent(IgePathComponent);
    }
    this.streamSections(['transform', 'direction']);
  },
  streamSectionData: function(sectionId, data) {
    if (sectionId === 'direction') {
      if (!ige.isServer) {
        if (data) {
          this._streamDir = data;
        } else {
          this._streamDir = 'stop';
        }
      } else {
        return this._streamDir;
      }
    } else {
      return IgeEntity.prototype.streamSectionData.call(this, sectionId, data);
    }
  },
  update: function(ctx) {
    var dir;
    if (ige.isServer) {
      this._streamDir = this.path.currentDirection();
    } else {
      this.depth(this._translate.y);
      if (this._streamDir) {
        if (this._streamDir !== this._currentDir || !this.character.animation.playing()) {
          this._currentDir = this._streamDir;
          dir = this._streamDir;
          switch (this._streamDir) {
            case 'S':
              dir = 'W';
              break;
            case 'E':
              dir = 'E';
              break;
            case 'N':
              dir = 'E';
              break;
            case 'W':
              dir = 'W';
          }
          if (dir && dir !== 'stop') {
            this.character.animation.start(dir);
          } else {
            this.character.animation.stop();
          }
        }
      } else {
        this.character.animation.stop();
      }
    }
    IgeEntity.prototype.update.call(this, ctx);
  }
});


},{}],4:[function(require,module,exports){
module.exports = {
  _onPlayerEntity: function(data) {
    var self;
    if (ige.$(data)) {
      ige.$(data).addComponent(PlayerComponent);
      return ige.client.vp1.camera.trackTranslate(ige.$(data), 50);
    } else {
      self = this;
      return self._eventListener = ige.network.stream.on('entityCreated', function(entity) {
        if (entity.id() === data) {
          ige.$(data).addComponent(PlayerComponent);
          ige.client.vp1.camera.trackTranslate(ige.$(data), 50);
          return ige.network.stream.off('entityCreated', self._eventListener, function(result) {
            if (!result) {
              return this.log('Could not disable event listener!', 'warning');
            }
          });
        }
      });
    }
  }
};


},{}],5:[function(require,module,exports){
module.exports = IgeEntity.extend({
  classId: 'PlayerComponent',
  componentId: 'playerControl',
  init: function(entity, options) {
    var self;
    self = this;
    this._entity = entity;
    this._options = options;
    if (!ige.isServer) {
      return ige.client.textureMap1.mouseUp(function(tileX, tileY, event) {
        return ige.network.send('playerControlToTile', [tileX, tileY]);
      });
    }
  }
});


},{}]},{},[1]);
