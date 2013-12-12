// Generated by CoffeeScript 1.6.3
(function() {
  var InstructionVisitor, Link, Root, View,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Root = (function() {
    function Root(origin, nextLink) {
      this.origin = origin;
      this.nextLink = nextLink != null ? nextLink : null;
      this.endParticle = __bind(this.endParticle, this);
      this.end = new Particle(this.origin);
    }

    Root.prototype.endParticle = function() {
      return this.end;
    };

    return Root;

  })();

  Link = (function() {
    function Link(name, color, parent, startParticle, extent, direction) {
      this.name = name;
      this.color = color;
      this.parent = parent;
      this.startParticle = startParticle;
      this.extent = extent;
      this.direction = direction;
      this.unlink = __bind(this.unlink, this);
      this.markDead = __bind(this.markDead, this);
      this.endParticle = __bind(this.endParticle, this);
      this.end = new Particle(this.startParticle.pos.add(this.direction.scale(this.extent)));
      this.end.link = this;
      this.dead = false;
      this.nextLink = null;
    }

    Link.prototype.endParticle = function() {
      return this.end;
    };

    Link.prototype.markDead = function() {
      if (this.nextLink != null) {
        this.nextLink.markDead();
      }
      return this.dead = true;
    };

    Link.prototype.unlink = function() {
      return this.parent.nextLink = this.nextLink;
    };

    return Link;

  })();

  InstructionVisitor = (function() {
    function InstructionVisitor(origin, parent) {
      this.origin = origin;
      this.parent = parent;
      this.visitNested = __bind(this.visitNested, this);
      this._drawParticles = __bind(this._drawParticles, this);
      this._addParticle = __bind(this._addParticle, this);
      this.visitForward = __bind(this.visitForward, this);
      this.direction = new Vec2(0.0, -1.0);
      this.stride = 20.0;
      this.composite = null;
      if (this.parent.nextLink != null) {
        this.parent.nextLink.markDead();
      }
    }

    InstructionVisitor.prototype.visitForward = function(name, color, extent) {
      var link;
      if ((this.parent.nextLink != null) && this.parent.nextLink.name === name) {
        this.parent.nextLink.dead = false;
        return this.parent = this.parent.nextLink;
      } else {
        link = new Link(name, color, this.parent, this.parent.endParticle(), extent * this.stride, this.direction);
        this.parent.nextLink = link;
        this.parent = link;
        return this._addParticle(link.endParticle());
      }
    };

    InstructionVisitor.prototype._addParticle = function(particle) {
      console.log("add");
      console.dir(particle);
      if (this.composite == null) {
        this.composite = new VerletJS.Composite();
        this.composite.drawParticles = this._drawParticles;
      }
      return this.composite.particles.push(particle);
    };

    InstructionVisitor.prototype._drawParticles = function(ctx, composite) {
      var end, particle, start, _i, _len, _ref, _results;
      _ref = composite.particles;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        particle = _ref[_i];
        if (particle.link != null) {
          start = particle.link.startParticle;
          end = particle;
          ctx.beginPath();
          ctx.arc(end.pos.x, end.pos.y, 2, 0, 2 * Math.PI);
          ctx.fillStyle = particle.link.color;
          ctx.fill();
          ctx.beginPath();
          ctx.moveTo(start.pos.x, start.pos.y);
          ctx.lineTo(end.pos.x, end.pos.y);
          ctx.strokeStyle = "gray";
          _results.push(ctx.stroke());
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    InstructionVisitor.prototype.visitNested = function(nested) {
      var instruction, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = nested.length; _i < _len; _i++) {
        instruction = nested[_i];
        _results.push(instruction.accept(this));
      }
      return _results;
    };

    return InstructionVisitor;

  })();

  View = (function() {
    function View(model, id) {
      this.model = model;
      this._removeDeadParticles = __bind(this._removeDeadParticles, this);
      this._removeDeadLinks = __bind(this._removeDeadLinks, this);
      this._onEvaluationChange = __bind(this._onEvaluationChange, this);
      this._loop = __bind(this._loop, this);
      this._setup(id);
      this.model.evaluated.subscribe(this._onEvaluationChange);
    }

    View.prototype._setup = function(id) {
      var canvas, dpr, height, width;
      canvas = document.getElementById(id);
      width = parseInt(canvas.style.width);
      height = parseInt(canvas.style.height);
      dpr = window.devicePixelRatio || 1;
      canvas.width = width * dpr;
      canvas.height = height * dpr;
      canvas.getContext("2d").scale(dpr, dpr);
      this.sim = new VerletJS(width, height, canvas);
      this.sim.friction = 0.3;
      this.sim.gravity = new Vec2(0.0, 0.0);
      this.origin = new Vec2(width / 2, 3 * height / 4);
      this.root = new Root(this.origin);
      this._onEvaluationChange(this.model.evaluated());
      return this._loop();
    };

    View.prototype._loop = function() {
      this.sim.frame(16);
      this.sim.draw();
      return window.requestAnimFrame(this._loop);
    };

    View.prototype._onEvaluationChange = function(change) {
      var visitor;
      console.dir(change);
      visitor = new InstructionVisitor(this.origin, this.root);
      change.accept(visitor);
      if (visitor.composite != null) {
        this.sim.composites.push(visitor.composite);
      }
      this._removeDeadLinks();
      return this._removeDeadParticles();
    };

    View.prototype._removeDeadLinks = function() {
      var composite, deadLink, _i, _len, _ref, _results;
      _ref = this.sim.composites;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        composite = _ref[_i];
        _results.push((function() {
          var _j, _len1, _ref1, _results1,
            _this = this;
          _ref1 = _.chain(composite.particles).filter(function(p) {
            var _ref1;
            return (_ref1 = p.link) != null ? _ref1.dead : void 0;
          }).map(function(p) {
            return p.link;
          }).value();
          _results1 = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            deadLink = _ref1[_j];
            _results1.push(deadLink.unlink());
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    View.prototype._removeDeadParticles = function() {
      var composite, _i, _len, _ref,
        _this = this;
      _ref = this.sim.composites;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        composite = _ref[_i];
        console.log("before/after");
        console.dir(composite.particles);
        composite.particles = _.filter(composite.particles, function(p) {
          var _ref1;
          return !((_ref1 = p.link) != null ? _ref1.dead : void 0);
        });
        console.dir(composite.particles);
      }
      return this.sim.composites = _.filter(this.sim.composites, function(c) {
        return c.particles.length > 0;
      });
    };

    return View;

  })();

  window.View = View;

}).call(this);

/*
//@ sourceMappingURL=View.map
*/
