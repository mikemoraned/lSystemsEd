class Root
  constructor: (@origin, @nextLink = null) ->
    @end = new Particle(@origin)

  endParticle: () => @end

class Link
  constructor: (@name, @parent, @startParticle, @extent, @direction, @nextLink = null) ->
    @end = new Particle(@startParticle.pos.add(@direction.scale(@extent)))

  endParticle: () => @end

class InstructionVisitor

  constructor: (@origin, @parent) ->
    @nextStartParticle = new Particle(@origin)
    @direction = new Vec2(0.0, -1.0)
    @composite = null
    @stride = 20.0
    @prune = null

  visitForward: (name, extent) =>

    if @parent.nextLink?
      if @parent.nextLink.name == name
        @parent = @parent.nextLink
        @prune = @parent
      else
        link = new Link(name, @parent, @parent.endParticle(), extent * @stride, @direction)
        @parent.nextLink = link
        @parent = link
        @_addParticle(link.endParticle())
        @prune = null
    else
      link = new Link(name, @parent, @parent.endParticle(), extent * @stride, @direction)
      @parent.nextLink = link
      @parent = link
      @_addParticle(link.startParticle)
      @prune = null

  markDeadParticles: () =>
    dead = @_markDeadParticles(@prune)
    @prune.parent.nextLink = null
    dead

  _markDeadParticles: (curr) =>
    if curr?
      curr.endParticle().dead = true
      @_markDeadParticles(curr.nextLink)

  _addParticle: (particle) =>
    if !@composite?
      @composite = new VerletJS.Composite()
    @composite.particles.push(particle)

  visitNested: (nested) =>
    for instruction in nested
      instruction.accept(this)

class View
  constructor: (@model, id) ->
    @_setup(id)
    @model.evaluated.subscribe(@_onEvaluationChange)

  _setup: (id) ->
    canvas = document.getElementById(id)

    # canvas dimensions
    width = parseInt(canvas.style.width)
    height = parseInt(canvas.style.height)

    # retina
    dpr = window.devicePixelRatio || 1
    canvas.width = width*dpr
    canvas.height = height*dpr
    canvas.getContext("2d").scale(dpr, dpr)

    # simulation
    @sim = new VerletJS(width, height, canvas)
    @sim.friction = 0.3
    @sim.gravity = new Vec2(0.0, 0.0)

    # starting entities
    @origin = new Vec2(width/2, 3*height/4)
    @root = new Root(@origin)
    @_onEvaluationChange(@model.evaluated())

    # animation loop
    @_loop()

  _loop: () =>
    @sim.frame(16)
    @sim.draw()
    window.requestAnimFrame(@_loop)

  _onEvaluationChange: (change) =>
    console.dir(change)
    visitor = new InstructionVisitor(@origin, @root)
    change.accept(visitor)
    if visitor.composite?
      @sim.composites.push(visitor.composite)
    if visitor.prune?
      visitor.markDeadParticles()
      @_removeDeadParticles()

  _removeDeadParticles: () =>
    console.dir()
    for composite in @sim.composites
      console.log("before/after")
      console.dir(composite.particles)
      composite.particles = _.filter(composite.particles, (p) => !p.dead?)
      console.dir(composite.particles)

window.View = View