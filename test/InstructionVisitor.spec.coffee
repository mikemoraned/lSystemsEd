describe('InstructionVisitor', () =>
  describe('basic', () =>

    origin = new Vec2(0.0, 0.0)

    describe('visitForward', () =>
      it('forward moves one unit in default direction', () =>
        parent = new Root(origin)
        assert.isNull(parent.nextLink)
        visitor = new InstructionVisitor(origin, parent)
        visitor.visitForward('name','blue',1.0)
        assert.isNotNull(parent.nextLink)
        assert.equal(parent.nextLink.startParticle.pos.x, origin.x)
        assert.equal(parent.nextLink.startParticle.pos.y, origin.y)
        assert.equal(parent.nextLink.endParticle().pos.x, origin.x)
        assert.equal(parent.nextLink.endParticle().pos.y, origin.y - 20.0)
      )
    )
  )
)