class Forward
  constructor: (@name, @color) ->

  accept: (visitor) =>
    visitor.visitForward(@name, @color, 1.0)

class Nested
  constructor: (@nested) ->

  accept: (visitor) =>
    visitor.visitNested(@nested)

class Model

  constructor: (spec = "A") ->
    @commands = {}
    @commands["A"] = new Forward("A", "blue")
    @commands["B"] = new Forward("B", "red")
    @spec = ko.observable(spec)
    @evaluated = ko.computed(() =>
      new Nested(@spec().split("").map((i) => @commands[i]))
    )


window.Model = Model