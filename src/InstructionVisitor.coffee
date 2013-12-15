class InstructionVisitor

  constructor: (@pen) ->

  visitForward: (name, extent) =>
    @pen.drawLink(name, extent)
#    if @curr.nextLink? && @curr.nextLink.name == name
#      @curr = @pen.jumpTo(@curr.nextLink)
#    else
#      @pen.drawLink()
#      link = new Link(name, color, @parent, @parent.endParticle(), extent * @stride, @direction)
#      @parent.nextLink = link
#      @parent = link
#      @_addParticle(link.endParticle())

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