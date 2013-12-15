class DepthFirstIterator

  constructor: (@node) ->
    @stack = []

  hasNext: () =>
    @_findNextNode()
    @stack.length > 0

  next: () =>
    if !@hasNext()
      throw "no next node"
    @node = @stack.pop()

  _findNextNode: () =>
    if @stack.length == 0
      if @node.next?
        @stack.push(@node.next)

class Node

  constructor: (@name, @next) ->

  iterator: () =>
    new DepthFirstIterator(@)

window.Node = Node