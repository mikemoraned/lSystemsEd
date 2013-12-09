class Link
  constructor: (@startParticle, @extent, @direction, @nextLinks) ->

  endParticle: () =>
    new Particle(@startParticle.pos,@direction.scale(@extent))

class InstructionVisitor

  constructor: (@origin) ->
    @nextStartParticle = new Particle(@origin)
    @direction = new Vec2(0.0, 1.0)
    @composite = null
    @parent = null

  visitForward: (extent) =>

    if @parent?
      link = new Link(@parent.endParticle(), extent, @direction, [])
      @parent.nextLinks.push(link)
      @parent = link
    else
      @parent = new Link(new Particle(@origin), extent, @direction, [])

    if !@composite?
      @composite = new VerletJS.Composite()
    @composite.particles.push(@parent.startParticle)

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
#    @sim.gravity = new Vec2(0.0, 0.0)

    # starting entities
    @origin = new Vec2(width/2, 3*height/4)

#    composite = new VerletJS.Composite()
#    particle = new Particle(@origin)
#    composite.particles.push(particle)
#
#    @sim.composites.push(composite)

    @root = null

    # animation loop
    @_loop()

  _loop: () =>
    @sim.frame(16)
    @sim.draw()
    window.requestAnimFrame(@_loop)

  _onEvaluationChange: (change) =>
    console.dir(change)
    @newLinks = []
    visitor = new InstructionVisitor(@origin)
    change.accept(visitor)
    if visitor.composite?
      @sim.composites.push(visitor.composite)

window.View = View