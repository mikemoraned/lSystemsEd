class DepthFirstIterator

  constructor: (@node) ->
    @stack = []

  hasNext: () =>
    @_findNextNode()
    @stack.length > 0

  next: () =>
    if !@hasNext()
      throw new Error("no next node")
    @node = @stack.pop()

  replaceWith: (newNode) =>
    @node.name = newNode.name
    @node.next = newNode.next

  _findNextNode: () =>
    if @stack.length == 0
      if @node.next?
        @stack.push(@node.next)

class Node

  constructor: (@name, @next) ->

  iterator: () =>
    new DepthFirstIterator(@)

window.Node = Node