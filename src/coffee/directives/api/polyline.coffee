angular.module('uiGmapgoogle-maps.directives.api')
.factory 'uiGmapPolyline', [
  'uiGmapIPolyline', '$timeout', 'uiGmapPolylineChildModel', 'uiGmapFitHelper',
  (IPolyline, $timeout, PolylineChildModel, FitHelper) ->
    _children = {}
    class Polyline extends IPolyline
      @scope = _.extend IPolyline.scope,
        group: '=?'

      link: (scope, element, attrs, mapCtrl) =>
        scope.$on 'destroy', ->
          return unless scope.group?
          delete _children[scope.group] scope.$id

        _maybeFit = (map) =>
          return if !scope.fit
          return @$log.error 'cannot fit without a group' if !scope.group
          pathPoints = _.map _children[scope.group], (child) ->
            child.pathPoints.getArray()
          pathPoints = _.flatten pathPoints
          FitHelper.fit pathPoints, map

        IPolyline.mapPromise(scope, mapCtrl).then (map) =>
          # Validate required properties
          if angular.isUndefined(scope.path) or scope.path is null or not @validatePath(scope.path)
            @$log.warn 'polyline: no valid path attribute found'

          child = new PolylineChildModel scope, attrs, map, @DEFAULTS

          if scope.group?
            _children[scope.group] = {} if !_children[scope.group]?
            _children[scope.group][scope.$id] = child

          _maybeFit(map)


]
