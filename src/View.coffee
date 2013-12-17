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
    @_onEvaluationChange(@model.evaluated())

    # animation loop
    @_loop()

  _loop: () =>
    @sim.frame(16)
    @sim.draw()
    window.requestAnimFrame(@_loop)

  _onEvaluationChange: (change) =>
    console.dir(change)
    @root = new Node("root")
    builder = new VerletNodeBuilder(@origin, @root, @sim)
    change.accept(builder)
#    visitor = new InstructionVisitor(@origin, @root)
#    change.accept(visitor)
#    if visitor.composite?
#      @sim.composites.push(visitor.composite)
#    @_removeDeadLinks()
#    @_removeDeadParticles()

window.View = View