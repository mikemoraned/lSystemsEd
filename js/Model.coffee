class Model

  constructor: (spec = "L") ->
    @spec = ko.observable(spec)

window.Model = Model