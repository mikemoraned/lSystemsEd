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
      link = new Link(name, color, @parent, @parent.endParticle(), extent * @stride, @direction)
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

window.InstructionVisitor = InstructionVisitor