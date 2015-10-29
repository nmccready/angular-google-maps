angular.module('uiGmapgoogle-maps.directives.api')
.factory 'uiGmapPolygon', [
  'uiGmapIPolygon', '$timeout', 'uiGmapPolygonChildModel', 'uiGmapFitHelper', 'uiGmapSingular'
  (IPolygon, $timeout, PolygonChild, FitHelper, Singular) ->
    _singular = new Singular()

    class Polygon extends IPolygon

      @scope = _.extend IPolygon.scope,
        group: '=?'

      link: (scope, element, attrs, mapCtrl) =>
        promise = IPolygon.mapPromise(scope, mapCtrl)

        _singular.link(scope)

        promise.then (map) =>
          child = new PolygonChild scope, attrs, map, @DEFAULTS
          children = _singular.addChild(scope, child)

          #backwards compat
          #TODO remove deprecated
          if scope.control?
            scope.control.getInstance = @
            scope.control.polygons = children
            scope.control.promise = promise

          FitHelper.maybeFit(map, children, scope)
]
