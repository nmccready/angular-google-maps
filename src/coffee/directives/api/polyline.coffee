angular.module('uiGmapgoogle-maps.directives.api')
.factory 'uiGmapPolyline', [
  'uiGmapIPolyline', '$timeout', 'uiGmapPolylineChildModel', 'uiGmapFitHelper', 'uiGmapSingular',
  (IPolyline, $timeout, PolylineChildModel, FitHelper, Singular) ->
    _singular = new Singular()
    class Polyline extends IPolyline
      @scope = _.extend IPolyline.scope,
        group: '=?'

      link: (scope, element, attrs, mapCtrl) =>
        _singular.link(scope)
        IPolyline.mapPromise(scope, mapCtrl).then (map) =>
          # Validate required properties
          if angular.isUndefined(scope.path) or scope.path is null or not @validatePath(scope.path)
            @$log.warn 'polyline: no valid path attribute found'

          children = _singular.addChild(scope, new PolylineChildModel scope, attrs, map, @DEFAULTS)

          FitHelper.maybeFit(map, children, scope)


]
