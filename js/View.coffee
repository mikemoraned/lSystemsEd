class View
  constructor: (@model, id) ->
    @_setup(id)

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

    composite = new VerletJS.Composite()
    particle = new Particle(@origin)
    composite.particles.push(particle)

    @sim.composites.push(composite)

    # animation loop
    @_loop()

  _loop: () =>
    @sim.frame(16)
    @sim.draw()
    window.requestAnimFrame(@_loop)


window.View = View