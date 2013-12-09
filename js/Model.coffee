class Forward
  accept: (visitor) =>
    visitor.visitForward(1)

class Nested
  constructor: (@nested) ->

  accept: (visitor) =>
    visitor.visitNested(@nested)

class Model

  constructor: (spec = "L") ->
    @commands = {}
    @commands["L"] = new Forward()
    @spec = ko.observable(spec)
    @evaluated = ko.computed(() =>
      new Nested(@spec().split("").map((i) => @commands[i]))
    )


window.Model = Model