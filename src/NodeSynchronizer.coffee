class NodeSynchronizer

  syncUp: (destIter, srcIter) =>
    if srcIter.node.name != destIter.node.name
      destIter.replaceWith(srcIter.node)
      if (destIter.hasNext())
        @syncUp(destIter.next(), srcIter.next())
    else
      if (srcIter.hasNext())
        if (destIter.hasNext())
          @syncUp(destIter.next(), srcIter.next())
        else
          destIter.append(srcIter.node.next)
          @syncUp(destIter.next(), srcIter.next())
      else
        if (destIter.hasNext())
          # cut in dest, end iteration
          destIter.cut()
        else
          # end iteration

window.NodeSynchronizer = NodeSynchronizer