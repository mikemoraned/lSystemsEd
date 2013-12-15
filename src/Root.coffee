class Root

  constructor: (@origin, @nextLink = null) ->
    @end = new Particle(@origin)

  endParticle: () => @end

window.Root = Root