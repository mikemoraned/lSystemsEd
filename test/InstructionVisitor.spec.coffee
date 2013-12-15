describe('InstructionVisitor', () =>
  describe('basic', () =>

    origin = new Vec2(0.0, -1.0)

    describe('visitForward', () =>
      it('single forward moves one unit in default direction', () =>
        parent = new Root(origin)
        visitor = new InstructionVisitor(origin, parent)
        assert.equal(false, true, "to be completed")
      )
    )
  )
)