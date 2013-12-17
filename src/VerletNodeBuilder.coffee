class VerletLink

  constructor: (startPos, endPos, @color) ->
    @start = new Particle(startPos)
    @end = new Particle(endPos)
    @end.link = this

  addToComposite: (composite) =>
    composite.particles.push(@end)

  draw: (ctx) =>
    ctx.beginPath()
    ctx.arc(@end.pos.x, @end.pos.y, 2, 0, 2*Math.PI)
    ctx.fillStyle = @color
    ctx.fill()
    ctx.beginPath()
    ctx.moveTo(@start.pos.x, @start.pos.y)
    ctx.lineTo(@end.pos.x, @end.pos.y)
    ctx.strokeStyle = "gray"
    ctx.stroke()

class VerletNodeBuilder

  constructor: (origin, @root, @sim) ->
    @position = origin
    @stride = 20.0
    @direction = new Vec2(0.0, -1.0)

  visitForward: (name, color, extent) =>
    node = new Node(name)

    start = @position
    end = @position.add(@direction.scale(extent * @stride))

    link = new VerletLink(start, end, color)
    node.link = link
    @composite.drawParticles = @_drawParticles
    link.addToComposite(@composite)

    @root.nextLink = link
    @root = link
    @position = end

  visitNested: (nested) =>
    @composite = new VerletJS.Composite()
    for instruction in nested
      instruction.accept(this)
    @sim.composites.push(@composite)

  _drawParticles: (ctx, composite) =>
    for particle in composite.particles
      if particle.link?
        particle.link.draw(ctx)


window.VerletNodeBuilder = VerletNodeBuilder