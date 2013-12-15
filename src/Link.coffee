class Link
  constructor: (@name, @color, @parent, @startParticle, @extent, @direction) ->
    @end = new Particle(@startParticle.pos.add(@direction.scale(@extent)))
    @end.link = this
    @dead = false
    @nextLink = null

  endParticle: () => @end

  markDead: () =>
    if @nextLink?
      @nextLink.markDead()
    @dead = true

  unlink: () =>
    @parent.nextLink = @nextLink

window.Link = Link