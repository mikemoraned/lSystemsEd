describe('NodeSynchronizer', () =>

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

  describe('identical', () =>

    it('single node', () =>
      dest = new Node("A")
      src = new Node("A")

      new NodeSynchronizer().syncUp(dest.iterator(), src.iterator())

      assertHasIterationEqual(dest, ["A"])
      assertHasIterationEqual(src, ["A"])
    )

    it('multi-level, same size', () =>
      dest = new Node("A", new Node("B"))
      src = new Node("A", new Node("B"))

      new NodeSynchronizer().syncUp(dest.iterator(), src.iterator())

      assertHasIterationEqual(dest, ["A","B"])
      assertHasIterationEqual(src, ["A","B"])
    )
  )

  describe('different', () =>

    it('single node', () =>
      dest = new Node("A")
      src = new Node("B")

      new NodeSynchronizer().syncUp(dest.iterator(), src.iterator())

      assertHasIterationEqual(dest, ["B"])
      assertHasIterationEqual(src, ["B"])
    )

    it('multi-level, totally different, same size', () =>
      dest = new Node("A", new Node("B"))
      src = new Node("C", new Node("D"))

      new NodeSynchronizer().syncUp(dest.iterator(), src.iterator())

      assertHasIterationEqual(dest, ["C","D"])
      assertHasIterationEqual(src, ["C","D"])
    )

    it('multi-level, totally different, src bigger', () =>
      dest = new Node("A", new Node("B"))
      src = new Node("C", new Node("D", new Node("E")))

      new NodeSynchronizer().syncUp(dest.iterator(), src.iterator())

      assertHasIterationEqual(dest, ["C","D","E"])
      assertHasIterationEqual(src, ["C","D","E"])
    )

    it('multi-level, totally different, dest bigger', () =>
      dest = new Node("A", new Node("B", new Node("C")))
      src = new Node("D", new Node("E", new Node("F")))

      new NodeSynchronizer().syncUp(dest.iterator(), src.iterator())

      assertHasIterationEqual(dest, ["D","E","F"])
      assertHasIterationEqual(src, ["D","E","F"])
    )

    it('multi-level, shared prefix, same size', () =>
      dest = new Node("A", new Node("B", new Node("C")))
      src = new Node("A", new Node("D", new Node("E")))

      new NodeSynchronizer().syncUp(dest.iterator(), src.iterator())

      assertHasIterationEqual(dest, ["A","D","E"])
      assertHasIterationEqual(src, ["A","D","E"])
    )

    it('multi-level, shared prefix, dest bigger', () =>
      dest = new Node("A")
      src = new Node("A", new Node("D", new Node("E")))

      new NodeSynchronizer().syncUp(dest.iterator(), src.iterator())

      assertHasIterationEqual(dest, ["A","D","E"])
      assertHasIterationEqual(src, ["A","D","E"])
    )

    it('multi-level, shared prefix, src bigger', () =>
      dest = new Node("A", new Node("B", new Node("C")))
      src = new Node("A")

      new NodeSynchronizer().syncUp(dest.iterator(), src.iterator())

      assertHasIterationEqual(dest, ["A"])
      assertHasIterationEqual(src, ["A"])
    )
  )
)