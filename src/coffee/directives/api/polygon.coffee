angular.module('uiGmapgoogle-maps.directives.api')
.factory 'uiGmapPolygon', [
  'uiGmapIPolygon', '$timeout', 'uiGmapPolygonChildModel'
  (IPolygon, $timeout, PolygonChild) ->
    class Polygon extends IPolygon
      link: (scope, element, attrs, mapCtrl) =>
        children = {}
        scope.$on 'destroy', ->
          delete children scope.$id
        promise = IPolygon.mapPromise(scope, mapCtrl)
        if scope.control?
          scope.control.getInstance = @
          scope.control.polygons = children
          scope.control.promise = promise

        promise.then (map) =>
          children[scope.$id] = new PolygonChild scope, attrs, map, @DEFAULTS
]
