// Generated by CoffeeScript 1.6.3
(function() {
  var Forward, Model, Nested,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Forward = (function() {
    function Forward(name, color) {
      this.name = name;
      this.color = color;
      this.accept = __bind(this.accept, this);
    }

    Forward.prototype.accept = function(visitor) {
      return visitor.visitForward(this.name, this.color, 1.0);
    };

    return Forward;

  })();

  Nested = (function() {
    function Nested(nested) {
      this.nested = nested;
      this.accept = __bind(this.accept, this);
    }

    Nested.prototype.accept = function(visitor) {
      return visitor.visitNested(this.nested);
    };

    return Nested;

  })();

  Model = (function() {
    function Model(spec) {
      var _this = this;
      if (spec == null) {
        spec = "A";
      }
      this.commands = {};
      this.commands["A"] = new Forward("A", "blue");
      this.commands["B"] = new Forward("B", "red");
      this.spec = ko.observable(spec);
      this.evaluated = ko.computed(function() {
        return new Nested(_this.spec().split("").map(function(i) {
          return _this.commands[i];
        }));
      });
    }

    return Model;

  })();

  window.Model = Model;

}).call(this);

/*
//@ sourceMappingURL=Model.map
*/
