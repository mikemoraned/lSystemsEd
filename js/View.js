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
    function Link(name, parent, startParticle, extent, direction, nextLink) {
      this.name = name;
      this.parent = parent;
      this.startParticle = startParticle;
      this.extent = extent;
      this.direction = direction;
      this.nextLink = nextLink != null ? nextLink : null;
      this.endParticle = __bind(this.endParticle, this);
      this.end = new Particle(this.startParticle.pos.add(this.direction.scale(this.extent)));
    }

    Link.prototype.endParticle = function() {
      return this.end;
    };

    return Link;

  })();

  InstructionVisitor = (function() {
    function InstructionVisitor(origin, parent) {
      this.origin = origin;
      this.parent = parent;
      this.visitNested = __bind(this.visitNested, this);
      this._addParticle = __bind(this._addParticle, this);
      this._markDeadParticles = __bind(this._markDeadParticles, this);
      this.markDeadParticles = __bind(this.markDeadParticles, this);
      this.visitForward = __bind(this.visitForward, this);
      this.nextStartParticle = new Particle(this.origin);
      this.direction = new Vec2(0.0, -1.0);
      this.composite = null;
      this.stride = 20.0;
      this.prune = null;
    }

    InstructionVisitor.prototype.visitForward = function(name, extent) {
      var link;
      if (this.parent.nextLink != null) {
        if (this.parent.nextLink.name === name) {
          this.parent = this.parent.nextLink;
          return this.prune = this.parent;
        } else {
          link = new Link(name, this.parent, this.parent.endParticle(), extent * this.stride, this.direction);
          this.parent.nextLink = link;
          this.parent = link;
          this._addParticle(link.endParticle());
          return this.prune = null;
        }
      } else {
        link = new Link(name, this.parent, this.parent.endParticle(), extent * this.stride, this.direction);
        this.parent.nextLink = link;
        this.parent = link;
        this._addParticle(link.startParticle);
        return this.prune = null;
      }
    };

    InstructionVisitor.prototype.markDeadParticles = function() {
      var dead;
      dead = this._markDeadParticles(this.prune);
      this.prune.parent.nextLink = null;
      return dead;
    };

    InstructionVisitor.prototype._markDeadParticles = function(curr) {
      if (curr != null) {
        curr.endParticle().dead = true;
        return this._markDeadParticles(curr.nextLink);
      }
    };

    InstructionVisitor.prototype._addParticle = function(particle) {
      if (this.composite == null) {
        this.composite = new VerletJS.Composite();
      }
      return this.composite.particles.push(particle);
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
      if (visitor.prune != null) {
        visitor.markDeadParticles();
        return this._removeDeadParticles();
      }
    };

    View.prototype._removeDeadParticles = function() {
      var composite, _i, _len, _ref, _results,
        _this = this;
      console.dir();
      _ref = this.sim.composites;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        composite = _ref[_i];
        console.log("before/after");
        console.dir(composite.particles);
        composite.particles = _.filter(composite.particles, function(p) {
          return p.dead == null;
        });
        _results.push(console.dir(composite.particles));
      }
      return _results;
    };

    return View;

  })();

  window.View = View;

}).call(this);

/*
//@ sourceMappingURL=View.map
*/
