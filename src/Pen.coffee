class Area

  constructor: () ->
    @composite = null

  addEndpointAt: (position, link) =>
    particle = new Particle(position)
    particle.link = link
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

#class Link
#
#  constructor: (@name, @color, @parent, @startParticle, @extent, @direction) ->
#    @end = new Particle(@startParticle.pos.add(@direction.scale(@extent)))
#    @end.link = this
#    @dead = false
#    @nextLink = null
#
#  endParticle: () => @end
#
#  markDead: () =>
#    if @nextLink?
#      @nextLink.markDead()
#    @dead = true
#
#  unlink: () =>
#    @parent.nextLink = @nextLink
#
#window.Link = Link

class Link


class Pen

  constructor: (origin) ->
    @curr = new Link(origin)
    @root = @curr

    @direction = new Vec2(0.0, -1.0)
    @stride = 20.0

    @area = new Area()

  drawLink: (name, extent) =>
    



window.Pen = Pen