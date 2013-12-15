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
    @_removeDeadLinks()
    @_removeDeadParticles()

  _removeDeadLinks: () =>
    for composite in @sim.composites
      for deadLink in _.chain(composite.particles).filter((p) => p.link?.dead).map((p) => p.link).value()
        deadLink.unlink()


  _removeDeadParticles: () =>
    for composite in @sim.composites
      console.log("before/after")
      console.dir(composite.particles)
      composite.particles = _.filter(composite.particles, (p) => !p.link?.dead)
      console.dir(composite.particles)
    @sim.composites = _.filter(@sim.composites, (c) => c.particles.length > 0)

window.View = View