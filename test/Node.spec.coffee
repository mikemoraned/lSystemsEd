describe('Node', () =>

  nextUntilEnd = (iter) ->
    names = []
    names.push(iter.node.name)
    while (iter.hasNext())
      iter.next()
      names.push(iter.node.name)
    names

  describe('read-only iteration', () =>

    it('single node', () =>
      tree = new Node("A")
      names = nextUntilEnd(tree.iterator())
      assert.deepEqual(names, ["A"])
    )

    it('non-empty, multi-level', () =>
      tree = new Node("A", new Node("B", new Node("A")))
      names = nextUntilEnd(tree.iterator())
      assert.deepEqual(names, ["A","B","A"])
    )
  )
)