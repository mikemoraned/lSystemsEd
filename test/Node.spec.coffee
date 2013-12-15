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
      list = new Node("A")

      iter = list.iterator()
      iter.replaceWith(new Node("B", new Node("C")))

      assert.deepEqual(nextUntilEnd(iter), ["B","C"])
      assertHasIterationEqual(list, ["B","C"])
    )

    it('multi-level list, single-node replacement, in middle', () =>
      list = new Node("A", new Node("B", new Node("C")))

      iter = list.iterator()
      iter.next()
      iter.replaceWith(new Node("D"))

      assert.deepEqual(nextUntilEnd(iter), ["D"])
      assertHasIterationEqual(list, ["A","D"])
    )

    it('multi-level list, multi-level replacement, in middle', () =>
      list = new Node("A", new Node("B", new Node("C")))

      iter = list.iterator()
      iter.next()
      iter.replaceWith(new Node("D", new Node("E")))

      assert.deepEqual(nextUntilEnd(iter), ["D","E"])
      assertHasIterationEqual(list, ["A","D","E"])
    )
  )

  describe('append', () =>

    it('single node, single node append', () =>
      tree = new Node("A")

      iter = tree.iterator()
      iter.append(new Node("B"))

      assert.deepEqual(nextUntilEnd(iter), ["A","B"])
      assertHasIterationEqual(tree, ["A","B"])
    )

    it('single node, multi-level append', () =>
      list = new Node("A")

      iter = list.iterator()
      iter.append(new Node("B", new Node("C")))

      assert.deepEqual(nextUntilEnd(iter), ["A","B","C"])
      assertHasIterationEqual(list, ["A", "B","C"])
    )

    it('multi-level list, single-node append, in middle', () =>
      list = new Node("A", new Node("B", new Node("C")))

      iter = list.iterator()
      iter.next()
      a = () => iter.append(new Node("D"))
      assert.throw(a, /illegal operation/)

      assert.deepEqual(nextUntilEnd(iter), ["B","C"])
      assertHasIterationEqual(list, ["A","B","C"])
    )

    it('multi-level list, multi-level append, in middle', () =>
      list = new Node("A", new Node("B", new Node("C")))

      iter = list.iterator()
      iter.next()
      a = () => iter.append(new Node("D", new Node("E")))
      assert.throw(a, /illegal operation/)

      assert.deepEqual(nextUntilEnd(iter), ["B","C"])
      assertHasIterationEqual(list, ["A","B","C"])
    )
  )

  describe('cut', () =>

    it('single node, cut', () =>
      tree = new Node("A")

      iter = tree.iterator()
      iter.append(new Node("B"))

      assert.deepEqual(nextUntilEnd(iter), ["A","B"])
      assertHasIterationEqual(tree, ["A","B"])
    )

    it('multi-level list, cut after start', () =>
      list = new Node("A", new Node("B", new Node("C")))

      iter = list.iterator()
      iter.cut()

      assert.deepEqual(nextUntilEnd(iter), ["A"])
      assertHasIterationEqual(list, ["A"])
    )

    it('multi-level list, cut in middle', () =>
      list = new Node("A", new Node("B", new Node("C")))

      iter = list.iterator()
      iter.next()
      iter.cut()

      assert.deepEqual(nextUntilEnd(iter), ["B"])
      assertHasIterationEqual(list, ["A","B"])
    )

    it('multi-level list, cut at end', () =>
      list = new Node("A", new Node("B", new Node("C")))

      iter = list.iterator()
      iter.next()
      iter.next()
      iter.cut()

      assert.deepEqual(nextUntilEnd(iter), ["C"])
      assertHasIterationEqual(list, ["A","B","C"])
    )
  )
)