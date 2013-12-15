describe('Node', () =>

  nextUntilEnd = (iter) ->
    names = []
    names.push(iter.node.name)
    while (iter.hasNext())
      iter.next()
      names.push(iter.node.name)
    names

  assertHasIterationEqual = (tree, expected) ->
    names = nextUntilEnd(tree.iterator())
    assert.deepEqual(names, expected)

  describe('read-only iteration', () =>

    it('single node', () =>
      tree = new Node("A")

      assertHasIterationEqual(tree, ["A"])
    )

    it('non-empty, multi-level tree', () =>
      tree = new Node("A", new Node("B", new Node("C")))
      assertHasIterationEqual(tree, ["A","B","C"])
    )
  )

  describe('replacement', () =>

    it('single node, single node replacement', () =>
      tree = new Node("A")

      iter = tree.iterator()
      iter.replaceWith(new Node("B"))

      assert.deepEqual(nextUntilEnd(iter), ["B"])
      assertHasIterationEqual(tree, ["B"])
    )

    it('single node, multi-level replacement', () =>
      tree = new Node("A")

      iter = tree.iterator()
      iter.replaceWith(new Node("B", new Node("C")))

      assert.deepEqual(nextUntilEnd(iter), ["B","C"])
      assertHasIterationEqual(tree, ["B","C"])
    )

    it('multi-level tree, single-node replacement, in middle', () =>
      tree = new Node("A", new Node("B", new Node("C")))

      iter = tree.iterator()
      iter.next()
      iter.replaceWith(new Node("D"))

      assert.deepEqual(nextUntilEnd(iter), ["D"])
      assertHasIterationEqual(tree, ["A","D"])
    )

    it('multi-level tree, multi-level replacement, in middle', () =>
      tree = new Node("A", new Node("B", new Node("C")))

      iter = tree.iterator()
      iter.next()
      iter.replaceWith(new Node("D", new Node("E")))

      assert.deepEqual(nextUntilEnd(iter), ["D","E"])
      assertHasIterationEqual(tree, ["A","D","E"])
    )
  )
)