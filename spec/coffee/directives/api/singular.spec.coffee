describe 'uiGmapSingular', ->

  groupTests =
    'no group': {}
    oneGroup:
      group: 1

  beforeEach ->

    @injects.push (uiGmapSingular) =>
      @subject = uiGmapSingular

    @injectAll()


    @scope = do ->
      scopeEvents = {}

      $on = (eventName, cb) ->
        # console.log eventName
        # console.log cb
        scopeEvents[eventName] = cb
      $fire = (eventName) ->
        scopeEvents[eventName]?()

      control: {}
      $id: 1
      $on: $on
      $fire: $fire

  it 'exist', ->
    expect(@subject).toBeDefined()

  it 'create new instance', ->
    instance = new @subject()
    expect(instance).toBeDefined()

  describe 'instance.addChild', ->

    for testName, maybeGroup of groupTests
      do(testName, maybeGroup) ->
        describe testName, ->
          it 'returns same children instance', ->
            instance = new @subject()
            child = {}
            _.extend @scope, maybeGroup
            children = instance.addChild(@scope, child)
            expect(children).toBeDefined()
            children2 = instance.addChild(@scope, {})
            expect(children == children2).toBeTruthy()

          describe 'child count', ->
            it 'adding one child', ->
              instance = new @subject()
              child = {}
              _.extend @scope, maybeGroup
              children = instance.addChild(@scope, child)
              expect(Object.keys(children).length).toBe(1)

            describe 'adding two', ->
              it 'same scope', ->
                instance = new @subject()
                child = {}
                child2 = {}
                _.extend @scope, maybeGroup
                children = instance.addChild(@scope, child)
                expect(Object.keys(children).length).toBe(1)
                children = instance.addChild(@scope, child2)
                expect(Object.keys(children).length).toBe(1)

              it 'diff scope', ->
                instance = new @subject()
                child = {}
                child2 = {}
                _.extend @scope, maybeGroup
                children = instance.addChild(@scope, child)
                expect(Object.keys(children).length).toBe(1)
                @scope.$id = 2
                children = instance.addChild(@scope, child2)
                expect(Object.keys(children).length).toBe(2)

  describe 'scope.control.getPlurals', ->

    for testName, maybeGroup of groupTests
      do(testName, maybeGroup) ->
        describe testName, ->
          describe 'child count', ->
            it 'adding one child', ->
              instance = new @subject()
              child = {}
              _.extend @scope, maybeGroup
              instance.link(@scope)
              instance.addChild(@scope, child)
              expect(Object.keys(@scope.control.getPlurals()).length).toBe(1)

            describe 'adding two', ->
              it 'same scope', ->
                instance = new @subject()
                child = {}
                child2 = {}
                _.extend @scope, maybeGroup
                instance.link(@scope)
                children = instance.addChild(@scope, child)
                expect(Object.keys(children).length).toBe(1)
                children = instance.addChild(@scope, child2)
                expect(Object.keys(@scope.control.getPlurals()).length).toBe(1)

              it 'diff scope', ->
                instance = new @subject()
                child = {}
                child2 = {}
                _.extend @scope, maybeGroup
                instance.link(@scope)
                children = instance.addChild(@scope, child)
                expect(Object.keys(children).length).toBe(1)
                @scope.$id = 2
                children = instance.addChild(@scope, child2)
                expect(Object.keys(@scope.control.getPlurals()).length).toBe(2)

  describe 'instance.destroyChild', ->

    for testName, maybeGroup of groupTests
      do(testName, maybeGroup) ->
        describe testName, ->
          describe 'child count', ->
            it 'adding one child', ->
              instance = new @subject()
              child = {}
              _.extend @scope, maybeGroup
              instance.addChild(@scope, child)
              children = instance.destroyChild(@scope)
              expect(Object.keys(children).length).toBe(0)

            describe 'adding two', ->
              it 'same scope', ->
                instance = new @subject()
                child = {}
                child2 = {}
                _.extend @scope, maybeGroup
                children = instance.addChild(@scope, child)
                expect(Object.keys(children).length).toBe(1)
                children = instance.addChild(@scope, child2)
                expect(Object.keys(children).length).toBe(1)
                children = instance.destroyChild(@scope)
                expect(Object.keys(children).length).toBe(0)

              it 'diff scope', ->
                instance = new @subject()
                child = {}
                child2 = {}
                _.extend @scope, maybeGroup
                children = instance.addChild(@scope, child)
                expect(Object.keys(children).length).toBe(1)
                @scope.$id = 2
                children = instance.addChild(@scope, child2)
                expect(Object.keys(children).length).toBe(2)
                children = instance.destroyChild(@scope)
                expect(Object.keys(children).length).toBe(1)

  describe "instance.$on 'destroy'", ->

    for testName, maybeGroup of groupTests
      do(testName, maybeGroup) ->
        describe testName, ->
          describe 'child count', ->
            it 'adding one child', ->
              instance = new @subject()
              child = {}
              _.extend @scope, maybeGroup
              instance.link(@scope)
              children = instance.addChild(@scope, child)
              @scope.$fire 'destroy'
              expect(Object.keys(children).length).toBe(0)

            describe 'adding two', ->
              it 'same scope', ->
                instance = new @subject()
                child = {}
                child2 = {}
                _.extend @scope, maybeGroup
                instance.link(@scope)
                children = instance.addChild(@scope, child)
                expect(Object.keys(children).length).toBe(1)
                children = instance.addChild(@scope, child2)
                expect(Object.keys(children).length).toBe(1)
                @scope.$fire 'destroy'
                expect(Object.keys(children).length).toBe(0)

              it 'diff scope', ->
                instance = new @subject()
                child = {}
                child2 = {}
                _.extend @scope, maybeGroup
                instance.link(@scope)
                children = instance.addChild(@scope, child)
                expect(Object.keys(children).length).toBe(1)
                @scope.$id = 2
                children = instance.addChild(@scope, child2)
                expect(Object.keys(children).length).toBe(2)
                @scope.$fire 'destroy'
                expect(Object.keys(children).length).toBe(1)
