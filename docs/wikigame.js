(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function (global){
var Boot, DrawPage, Game, LoadPage, Menu, Phaser, Preload, config, game, i, len, ref, state;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Patch together game states and start phaser in Boot state.
 */

config = require('./config.coffee');

Boot = require('./boot.coffee');

Preload = require('./preload.coffee');

Menu = require('./menu.coffee');

LoadPage = require('./loadpage.coffee');

DrawPage = require('./drawpage.coffee');

Game = require('./game.coffee');

if (config.debug) {
  ref = [Menu, Game];
  for (i = 0, len = ref.length; i < len; i++) {
    state = ref[i];
    state.prototype.render = function() {
      return this.game.debug.text(this.time.fps || '--', 2, 14, '#00FF00');
    };
  }
}

game = new Phaser.Game(config.width, config.height, Phaser.AUTO, config.id);

game.state.add('Boot', Boot);

game.state.add('Preload', Preload);

game.state.add('Menu', Menu);

game.state.add('LoadPage', LoadPage);

game.state.add('DrawPage', DrawPage);

game.state.add('Game', Game);

game.state.start('Boot');


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./boot.coffee":2,"./config.coffee":4,"./drawpage.coffee":5,"./game.coffee":6,"./loadpage.coffee":7,"./menu.coffee":8,"./preload.coffee":10}],2:[function(require,module,exports){
(function (global){
var Boot, Phaser, config,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Prepare loading bar image to show during preload.
 */

config = require('./config.coffee');

Boot = (function(superClass) {
  extend(Boot, superClass);

  function Boot() {
    Boot.__super__.constructor.apply(this, arguments);
  }

  Boot.prototype.preload = function() {
    return this.load.pack('boot', config.pack);
  };

  Boot.prototype.create = function() {
    return this.state.start('Preload');
  };

  return Boot;

})(Phaser.State);

module.exports = Boot;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./config.coffee":4}],3:[function(require,module,exports){
(function (global){
var FollowCamera, Phaser, config,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Allows game camera to follow an object (e.g. the player) slowly.
 */

config = require('./config.coffee');

FollowCamera = (function(superClass) {
  extend(FollowCamera, superClass);

  function FollowCamera(game, target) {
    this.target = target;
    FollowCamera.__super__.constructor.call(this, game, this.target.x, this.target.y, null);
    this.game.camera.bounds = null;
    this.game.camera.follow(this);
    this.game.physics.arcade.enable(this);
    this.body.allowGravity = false;
  }

  FollowCamera.prototype.update = function() {
    var dx, speed;
    if (this.target == null) {
      return;
    }
    dx = this.position.distance(this.target);
    speed = (dx > config.camera.slack) && (Math.pow(dx, 2) / config.camera.delay);
    return this.game.physics.arcade.moveToObject(this, this.target, speed);
  };

  return FollowCamera;

})(Phaser.Sprite);

module.exports = FollowCamera;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./config.coffee":4}],4:[function(require,module,exports){

/*
 * Constants used in client application.
 */
module.exports = {
  width: 820,
  height: 640,
  pack: 'assets/pack.json',
  debug: true,
  loadTimeout: 4000,
  startPage: 'Cruft',
  tagline: 'From Wikipedia, the free encyclopedia',
  gravity: 800,
  camera: {
    slack: 50,
    delay: 80
  },
  playerCfg: {
    mass: 10,
    acceleration: 60,
    maxSpeed: 300,
    maxFallSpeed: 1600,
    jumpSpeed: 500,
    jumpTime: 600,
    bounce: 0
  },
  wordCfg: {
    defaultStyle: {
      font: 'Sans-Serif',
      fontSize: 24,
      fill: '#000'
    },
    size: {
      note: 16,
      t3: 28,
      t2: 32,
      t1: 40,
      t0: 52
    }
  },
  spacing: {
    length: 1500,
    padding: 600,
    word: 50,
    line: 130,
    paragraph: 200,
    afterTitle: 100,
    beforeTagline: 78,
    blockSize: 200
  },
  color: {
    blue: '#0645AD',
    darkBlue: '#0B0080',
    red: '#CC2200',
    lightRed: '#A55858',
    brown: '#772233',
    lightBlue: '#3366BB',
    purple: '#663366'
  },
  type: {
    NEWLINE: 1,
    PRE: 2,
    POST: 3,
    WORD: 4,
    LINK: 5,
    TITLE0: 6,
    TITLE1: 7,
    TITLE2: 8,
    TITLE3: 9,
    BOLD: 10,
    ITAL: 11,
    TAGLINE: 12
  }
};


},{}],5:[function(require,module,exports){
(function (global){
var DrawPage, Phaser, Word, ref, spacing, type,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Page setup for main game state.
 *
 * Builds page from list of word objects, separating them into fixed size
 * "blocks" that are only rendered and processed when part of the block is on
 * screen. Shows a loading bar based on the number of blocks loaded.
 */

ref = require('./config.coffee'), spacing = ref.spacing, type = ref.type;

Word = require('./word.coffee');

DrawPage = (function(superClass) {
  extend(DrawPage, superClass);

  function DrawPage() {
    DrawPage.__super__.constructor.apply(this, arguments);
  }

  DrawPage.prototype.drawHoriz = function(y) {
    var gfx;
    gfx = this.add.graphics(0, 0);
    gfx.lineStyle(1, 0x808080, 1);
    gfx.moveTo(spacing.padding, y);
    return gfx.lineTo(spacing.length, y);
  };

  DrawPage.prototype.init = function(words) {
    this.words = words;
    console.log(this.words.length + ' words');
    this.x = this.y = spacing.padding;
    this.lastType = type.NEWLINE;
    this.blocks = [];
    this.idx = 0;
    return this.numBlocks = 1 + Math.floor(this.words.length / spacing.blockSize);
  };

  DrawPage.prototype.create = function() {
    this.loadSprite = this.add.sprite(this.game.camera.width / 2 - 200, this.game.camera.height / 2 - 20, 'preloadBar');
    this.loadSprite.fixedToCamera = true;
    this.loadWidth = this.loadSprite.width;
    this.loadRect = new Phaser.Rectangle(0, 0, 1, this.loadSprite.height);
    return this.loadSprite.crop(this.loadRect);
  };

  DrawPage.prototype.update = function() {
    var block, i, j, ref1, word;
    if (this.idx >= this.words.length) {
      this.world.resize(spacing.length + 2 * spacing.padding, this.w.bottom + spacing.padding);
      this.loadSprite.destroy();
      return this.state.start('Game', false, false, this.blocks);
    }
    block = {
      group: new Phaser.Group(this.game, null),
      onScreen: false,
      top: this.y,
      bottom: this.y
    };
    for (i = j = 0, ref1 = spacing.blockSize; 0 <= ref1 ? j < ref1 : j > ref1; i = 0 <= ref1 ? ++j : --j) {
      word = this.words[this.idx++];
      if (this.idx > this.words.length) {
        break;
      }
      if (word.t === type.NEWLINE) {
        this.x = spacing.padding;
        this.y += (function() {
          switch (this.lastType) {
            case type.TITLE0:
              return spacing.beforeTagline;
            case type.TAGLINE:
            case type.TITLE1:
            case type.TITLE2:
            case type.TITLE3:
              return spacing.afterTitle;
            default:
              return spacing.paragraph;
          }
        }).call(this);
        this.lastType = word.t;
        continue;
      }
      if (this.lastType === type.PRE || word.t === type.POST) {
        this.x -= spacing.word;
      } else if (this.x > spacing.length) {
        this.x = spacing.padding;
        this.y += spacing.line;
      }
      this.w = new Word(this.game, this.x, this.y, word);
      block.group.add(this.w);
      if (this.lastType === type.NEWLINE && (word.t === type.TITLE0 || word.t === type.TITLE1)) {
        this.drawHoriz(this.w.bottom);
      }
      this.x += this.w.width + spacing.word;
      this.lastType = word.t;
    }
    block.bottom = this.y;
    this.blocks.push(block);
    this.loadRect.width = Math.floor(this.loadWidth * this.blocks.length / this.numBlocks);
    return this.loadSprite.updateCrop();
  };

  return DrawPage;

})(Phaser.State);

module.exports = DrawPage;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./config.coffee":4,"./word.coffee":13}],6:[function(require,module,exports){
(function (global){
var FollowCamera, Game, Phaser, Player, spacing,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Main game state.
 *
 * Creates player and sets up camera. Handles collisions and lazy rendering of
 * blocks, which will have been created and passed in from the previous state.
 */

spacing = require('./config.coffee').spacing;

Player = require('./player.coffee');

FollowCamera = require('./camera.coffee');

Game = (function(superClass) {
  extend(Game, superClass);

  function Game() {
    Game.__super__.constructor.apply(this, arguments);
  }

  Game.prototype.init = function(blocks) {
    this.blocks = blocks;
    console.log(this.blocks.length + ' blocks');
    this.blocksOnScreen = 0;
  };

  Game.prototype.create = function() {
    this.movers = this.add.group();
    this.player = new Player(this.game, spacing.padding + 32, spacing.padding - 48, 'player');
    this.movers.add(this.player);
    return this.focus = this.add.existing(new FollowCamera(this.game, this.player));
  };

  Game.prototype.update = function() {
    var block, bottom, i, j, len, len1, ref, ref1, results, top;
    top = this.camera.y;
    bottom = top + this.camera.height;
    top = Math.min(top, this.player.body.y);
    bottom = Math.max(bottom, this.player.body.bottom);
    ref = this.blocks;
    for (i = 0, len = ref.length; i < len; i++) {
      block = ref[i];
      if (bottom >= block.top && top <= block.bottom) {
        if (!block.onScreen) {
          this.world.add(block.group);
        }
        block.onScreen = true;
      } else {
        if (block.onScreen) {
          this.world.remove(block.group);
        }
        block.onScreen = false;
      }
    }
    ref1 = this.blocks;
    results = [];
    for (j = 0, len1 = ref1.length; j < len1; j++) {
      block = ref1[j];
      if (block.onScreen) {
        results.push(this.physics.arcade.collide(this.movers, block.group, function(mover, platform) {
          if (platform.onCollision != null) {
            platform.onCollision(mover);
          }
          if (mover.onPlatform != null) {
            return mover.onPlatform(platform);
          }
        }));
      }
    }
    return results;
  };

  return Game;

})(Phaser.State);

module.exports = Game;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./camera.coffee":3,"./config.coffee":4,"./player.coffee":9}],7:[function(require,module,exports){
(function (global){
var LoadPage, Phaser, config, wikipedia, wikitext,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Request parsed (JSON) wiki page from server before starting main game state.
 */

config = require('./config.coffee');

wikipedia = require('./wikipedia.coffee');

wikitext = require('./wikitext.coffee');

LoadPage = (function(superClass) {
  extend(LoadPage, superClass);

  function LoadPage() {
    LoadPage.__super__.constructor.apply(this, arguments);
  }

  LoadPage.prototype.init = function(title) {
    this.title = title;
    console.log(this.title);
  };

  LoadPage.prototype.create = function() {
    var fail, fill, fontSize, message, succeed, text, x, y;
    x = this.game.camera.width / 2;
    y = this.game.camera.height / 2;
    message = 'Loading...';
    fontSize = 32;
    fill = '#000';
    text = this.add.text(x, y, message, {
      fontSize: fontSize,
      fill: fill
    });
    text.anchor.setTo(0.5, 0.5);
    text.fixedToCamera = true;
    succeed = function(data) {
      var page;
      page = wikitext.parse(this.title, data.query.pages[0].revisions[0].content);
      return this.state.start('DrawPage', true, false, page);
    };
    fail = function(error) {
      return this.state.start('Menu', true, false, error);
    };
    return wikipedia.getPage(this.title, succeed, fail, this);
  };

  return LoadPage;

})(Phaser.State);

module.exports = LoadPage;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./config.coffee":4,"./wikipedia.coffee":11,"./wikitext.coffee":12}],8:[function(require,module,exports){
(function (global){
var Menu, Phaser, config,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Placeholder for real menu.
 */

config = require('./config.coffee');

Menu = (function(superClass) {
  extend(Menu, superClass);

  function Menu() {
    Menu.__super__.constructor.apply(this, arguments);
  }

  Menu.prototype.init = function(error) {
    this.error = error;
  };

  Menu.prototype.create = function() {
    var fill, fontSize, logo, message, text, x, y;
    x = this.game.camera.width / 2;
    y = this.game.camera.height / 2;
    logo = this.add.sprite(x, y, 'wikipediaLogo');
    logo.anchor.setTo(0.5, 1);
    logo.fixedToCamera = true;
    fontSize = 32;
    if (this.error != null) {
      console.log(this.error);
      message = (this.error.name != null) && (this.error.message != null) ? this.error.name + ': ' + this.error.message : this.error;
      fill = '#F00';
      text = this.add.text(x, y, message, {
        fontSize: fontSize,
        fill: fill
      });
      text.anchor.setTo(0.5, 0);
      text.fixedToCamera = true;
    }
    message = '\n\nClick to start';
    fill = '#000';
    text = this.add.text(x, y, message, {
      fontSize: fontSize,
      fill: fill
    });
    text.anchor.setTo(0.5, 0);
    return text.fixedToCamera = true;
  };

  Menu.prototype.update = function() {
    if (this.input.activePointer.justPressed()) {
      return this.state.start('LoadPage', true, false, config.startPage);
    }
  };

  return Menu;

})(Phaser.State);

module.exports = Menu;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./config.coffee":4}],9:[function(require,module,exports){
(function (global){
var Phaser, Player, playerCfg,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Class for player sprite. Handles user input.
 *
 * Features smooth acceleration with instant stopping, jump height controlled by
 * length of button press, and allows a single air-jump after falling.
 */

playerCfg = require('./config.coffee').playerCfg;

Player = (function(superClass) {
  extend(Player, superClass);

  function Player(game, x, y) {
    Player.__super__.constructor.call(this, game, x, y, 'player');
    this.game.physics.arcade.enable(this);
    this.body.mass = playerCfg.mass;
    this.body.maxVelocity.x = playerCfg.maxSpeed;
    this.body.maxVelocity.y = playerCfg.maxFallSpeed;
    this.body.bounce.y = playerCfg.bounce;
    this.body.collideWorldBounds = true;
    this.anchor.setTo(0.5, 0.5);
    this.platform = null;
    this.jumpEvent = null;
    this.jumping = false;
    this.canJump = false;
  }

  Player.prototype.jump = function() {
    this.jumping = true;
    this.canJump = false;
    this.body.velocity.y = -1 * playerCfg.jumpSpeed;
    return this.jumpEvent = this.game.time.events.add(playerCfg.jumpTime, this.endJump, this);
  };

  Player.prototype.endJump = function() {
    this.body.velocity.y = Math.max(this.body.velocity.y / 2, this.body.velocity.y);
    return this.jumping = false;
  };

  Player.prototype.update = function() {
    switch (false) {
      case !this.game.cursors.left.isDown:
        this.body.velocity.x -= playerCfg.acceleration;
        this.scale.x = -1;
        break;
      case !this.game.cursors.right.isDown:
        this.body.velocity.x += playerCfg.acceleration;
        this.scale.x = 1;
        break;
      default:
        this.body.velocity.x = 0;
    }
    if (this.body.touching.down) {
      this.canJump = true;
    }
    if (this.jumping && !this.game.cursors.up.isDown) {
      this.game.time.events.remove(this.jumpEvent);
      this.endJump();
    }
    if (this.game.cursors.up.isDown && this.canJump) {
      this.jump();
    }
    if (this.body.blocked.down && !this.body.touching.down) {
      return this.onKilled();
    }
  };

  Player.prototype.onPlatform = function(platform) {
    if (this.game.cursors.down.isDown && this.body.touching.down && (platform.link != null)) {
      return this.game.state.start('LoadPage', true, false, platform.link);
    }
  };

  Player.prototype.onKilled = function() {
    return this.game.state.start('Menu', true, false, 'You died!');
  };

  return Player;

})(Phaser.Sprite);

module.exports = Player;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./config.coffee":4}],10:[function(require,module,exports){
(function (global){
var Phaser, Preload, config,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Loads assets used throughout the game. Does not deal with wiki pages.
 */

config = require('./config.coffee');

Preload = (function(superClass) {
  extend(Preload, superClass);

  function Preload() {
    Preload.__super__.constructor.apply(this, arguments);
  }

  Preload.prototype.preload = function() {
    this.load.setPreloadSprite(this.add.sprite(this.game.world.centerX - 200, this.game.world.centerY - 20, 'preloadBar'));
    this.stage.backgroundColor = '#fff';
    this.game.renderer.renderSession.roundPixels = true;
    this.time.advancedTiming = config.debug;
    this.physics.startSystem(Phaser.Physics.ARCADE);
    this.physics.arcade.gravity.y = config.gravity;
    this.game.cursors = this.input.keyboard.createCursorKeys();
    return this.load.pack('main', config.pack);
  };

  Preload.prototype.create = function() {
    return this.state.start('Menu');
  };

  return Preload;

})(Phaser.State);

module.exports = Preload;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./config.coffee":4}],11:[function(require,module,exports){
var config, getJSONP;

config = require('./config.coffee');


/*
 * Fetch a Wikipedia page using JSONP.
 *
 * Should switch to something more elegant in the future. In particular there's
 * no way to set user-agent headers using JSONP, and we don't want to make the
 * Wikimedia people mad.
 */

getJSONP = function(url, succeed, fail, context) {
  var finished, head, script, ud;
  ud = '_' + +(new Date);
  script = document.createElement('script');
  head = (document.getElementsByTagName('head'))[0] || document.documentElement;
  finished = 'finished' + ud;
  window[finished] = false;
  window[ud] = function(data) {
    window[finished] = true;
    head.removeChild(script);
    return succeed && succeed.call(context, data);
  };
  script.src = url + '&callback=' + ud;
  head.appendChild(script);
  return setTimeout((function() {
    if (!window[finished]) {
      return fail.call(context, new Error('Network Error'));
    }
  }), config.loadTimeout);
};

module.exports = {
  getPage: function(title, succeed, fail, context) {
    var url;
    url = "https://en.wikipedia.org/w/api.php?action=query" + ("&titles=" + title + "&prop=revisions&rvprop=content&continue=") + "&format=json&formatversion=2";
    return getJSONP(url, succeed, fail, context);
  }
};


},{"./config.coffee":4}],12:[function(require,module,exports){
var parse, parseLink, parseText, preprocess, punc, re, ref, tagline, type;

ref = require('./config.coffee'), type = ref.type, tagline = ref.tagline;


/*
 * Parse a limited subset of wikitext markup into JSON.
 */

preprocess = function(text) {
  var re;
  re = /(?:\<\/?\s*code\s*\>|\<\s*(\w*?)(?:\s.*?)?\>[^]*?\<\/\s*\1\s*\>|\<\!\-\-[^]*?\-\-\>|\<[^]*?\/\>|\{\|[^]*?\|\}|\{\{(?:\{\{[^]*?\}\}|[^])*?\}\})/g;
  return text.replace(re, '').trim();
};

parseText = function(type, text) {
  return text.split(/\s/).map(function(s) {
    return {
      t: type,
      w: s
    };
  });
};

parseLink = function(text) {
  var link, segs;
  segs = text.split('|');
  if (segs.length > 2) {
    return [];
  }
  link = segs[0], text = segs[segs.length - 1];
  link = link[0].toUpperCase() + link.slice(1);
  return text.split(/\s/).map(function(s) {
    return {
      t: type.LINK,
      w: s,
      link: link
    };
  });
};

punc = '"\'.,;:!?()[\\]{}';

re = RegExp("^\\s*(?:\\[\\[(.*?)\\]\\]|\\=\\=\\=\\=(.*?)\\=\\=\\=\\=|\\=\\=\\=(.*?)\\=\\=\\=|\\=\\=(.*?)\\=\\=|'''(.*?)'''|''(.*?)''|([" + punc + "]+)(?!\\S)|([" + punc + "]+)|(\\S*[^\\s" + punc + "]))");

parse = function(title, text) {
  var end, i, len, m, match, pos, sec, sections, tokens;
  sections = (preprocess(text)).split('\n');
  tokens = parseText(type.TITLE0, title);
  tokens.push({
    t: type.NEWLINE
  });
  tokens.push({
    t: type.TAGLINE,
    w: tagline
  });
  tokens.push({
    t: type.NEWLINE
  });
  for (i = 0, len = sections.length; i < len; i++) {
    sec = sections[i];
    pos = 0;
    end = sec.length;
    while ((pos < end) && ((match = re.exec(sec.slice(pos, end))) != null)) {
      pos += match[0].length;
      switch (false) {
        case (m = match[1]) == null:
          tokens = tokens.concat(parseLink(m));
          break;
        case (m = match[2]) == null:
          tokens = tokens.concat(parseText(type.TITLE3, m));
          break;
        case (m = match[3]) == null:
          tokens = tokens.concat(parseText(type.TITLE2, m));
          break;
        case (m = match[4]) == null:
          tokens = tokens.concat(parseText(type.TITLE1, m));
          break;
        case (m = match[5]) == null:
          tokens = tokens.concat(parseText(type.BOLD, m));
          break;
        case (m = match[6]) == null:
          tokens = tokens.concat(parseText(type.ITAL, m));
          break;
        case (m = match[7]) == null:
          tokens.push({
            t: type.POST,
            w: m
          });
          break;
        case (m = match[8]) == null:
          tokens.push({
            t: type.PRE,
            w: m
          });
          break;
        case (m = match[9]) == null:
          tokens.push({
            t: type.WORD,
            w: m
          });
      }
    }
    if (tokens[tokens.length - 1].t !== type.NEWLINE) {
      tokens.push({
        t: type.NEWLINE
      });
    }
  }
  return tokens;
};

module.exports = {
  parse: parse
};


},{"./config.coffee":4}],13:[function(require,module,exports){
(function (global){
var Phaser, Word, color, ref, type, wordCfg,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Phaser = (typeof window !== "undefined" ? window['Phaser'] : typeof global !== "undefined" ? global['Phaser'] : null);


/*
 * Generates a solid text sprite from a word object.
 */

ref = require('./config.coffee'), wordCfg = ref.wordCfg, color = ref.color, type = ref.type;

Word = (function(superClass) {
  extend(Word, superClass);

  function Word(game, x, y, word) {
    var dhb, dht, h, k, ref1, style, text, v, w;
    text = word.w;
    style = {};
    ref1 = wordCfg.defaultStyle;
    for (k in ref1) {
      v = ref1[k];
      style[k] = v;
    }
    if (word.t === type.LINK) {
      style.fill = color.blue;
    }
    if (word.t === type.ITAL) {
      style.fontStyle = 'italic';
    }
    if (word.t === type.BOLD) {
      style.fontWeight = 'bold';
    }
    if (word.t === type.TAGLINE) {
      style.fontSize = wordCfg.size.note;
    }
    if (word.t === type.TITLE0) {
      style.font = 'Serif';
      style.fontSize = wordCfg.size.t0;
    }
    if (word.t === type.TITLE1) {
      style.font = 'Serif';
      style.fontSize = wordCfg.size.t1;
    }
    if (word.t === type.TITLE2) {
      style.fontSize = wordCfg.size.t2;
    }
    if (word.t === type.TITLE3) {
      style.fontSize = wordCfg.size.t3;
    }
    Word.__super__.constructor.call(this, game, x, y, text, style);
    this.link = word.link;
    this.game.physics.arcade.enable(this);
    this.body.allowGravity = false;
    this.body.immovable = true;
    h = this.body.height;
    w = this.body.width;
    dht = this.body.height / 5;
    dhb = this.body.height / 3;
    this.body.setSize(w, h - dht - dhb, 0, dht);
  }

  return Word;

})(Phaser.Text);

module.exports = Word;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./config.coffee":4}]},{},[1]);
