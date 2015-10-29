angular.module('uiGmapgoogle-maps.directives.api')
.factory 'uiGmapSingular', [ ->
  ->
    _children = {}

    _initControl = (scope) ->
      return unless scope.control?

      #to keep similiar interface to plurals, though signature is slightly confusing
      scope.control.getPlurals = ->
        if scope.group?
          return _children[scope.group]
        _children

    link: (scope) ->
      scope.$on 'destroy', =>
        @destroyChild(scope)

      _initControl(scope, parent)

    destroyChild: (scope) ->
      if scope.group?
        delete _children[scope.group][scope.$id]
        return _children[scope.group]

      delete _children[scope.$id]
      _children


    addChild: (scope, child) ->
      if scope.group?
        _children[scope.group] = {} if !_children[scope.group]?
        _children[scope.group][scope.$id] = child
        return _children[scope.group]

      _children[scope.$id] = child
      _children
]
