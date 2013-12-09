class Root
  constructor: (@origin, @nextLink = null) ->
    @end = new Particle(@origin)

  endParticle: () => @end

class Link
  constructor: (@name, @color, @startParticle, @extent, @direction) ->
    @end = new Particle(@startParticle.pos.add(@direction.scale(@extent)))
    @end.link = this
    @dead = false
    @nextLink = null

  endParticle: () => @end

  markDead: () =>
    if @nextLink?
      @nextLink.markDead()
    @dead = true

class InstructionVisitor

  constructor: (@origin, @parent) ->
    @direction = new Vec2(0.0, -1.0)
    @stride = 20.0
    @composite = null
    if @parent.nextLink?
      @parent.nextLink.markDead()

  visitForward: (name, color, extent) =>

    if @parent.nextLink? && @parent.nextLink.name == name
      @parent.nextLink.dead = false
      @parent = @parent.nextLink
    else
      link = new Link(name, color, @parent.endParticle(), extent * @stride, @direction)
      @parent.nextLink = link
      @parent = link
      @_addParticle(link.endParticle())

  _addParticle: (particle) =>
    console.log("add")
    console.dir(particle)
    if !@composite?
      @composite = new VerletJS.Composite()
      @composite.drawParticles = @_drawParticles
    @composite.particles.push(particle)

  _drawParticles: (ctx, composite) =>
    for particle in composite.particles
      if particle.link?
        start = particle.link.startParticle
        end = particle
        ctx.beginPath()
        ctx.arc(end.pos.x, end.pos.y, 2, 0, 2*Math.PI)
        ctx.fillStyle = particle.link.color
        ctx.fill()
        ctx.beginPath()
        ctx.moveTo(start.pos.x, start.pos.y)
        ctx.lineTo(end.pos.x, end.pos.y)
        ctx.strokeStyle = "gray"
        ctx.stroke()

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
    @_removeDeadParticles()

  _removeDeadParticles: () =>
    console.dir()
    for composite in @sim.composites
      console.log("before/after")
      console.dir(composite.particles)
      composite.particles = _.filter(composite.particles, (p) => !p.link?.dead)
      console.dir(composite.particles)
    @sim.composites = _.filter(@sim.composites, (c) => c.particles.length > 0)

window.View = View