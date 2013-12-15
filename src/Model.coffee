class Forward
  constructor: (@name) ->

  accept: (visitor) =>
    visitor.visitForward(@name, 1.0)

class Nested
  constructor: (@nested) ->

  accept: (visitor) =>
    visitor.visitNested(@nested)

class Model

  constructor: (spec = "A") ->
    @commands = {}
    @commands["A"] = new Forward("A")
    @commands["B"] = new Forward("B")
    @spec = ko.observable(spec)
    @evaluated = ko.computed(() =>
      new Nested(@spec().split("").map((i) => @commands[i]))
    )


window.Model = Model