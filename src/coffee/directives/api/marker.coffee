angular.module("uiGmapgoogle-maps.directives.api")
.factory "uiGmapMarker", [
  "uiGmapIMarker", "uiGmapMarkerChildModel", "uiGmapMarkerManager", "uiGmapLogger", "uiGmapSingular", "uiGmapFitHelper",
  (IMarker, MarkerChildModel, MarkerManager, $log, Singular, FitHelper) ->
    _singular = new Singular()
    class Marker extends IMarker
      constructor: ->
        super()
        @template = '<span class="angular-google-map-marker" ng-transclude></span>'
        $log.info @

      controller: ['$scope', '$element', ($scope, $element)  ->
        $scope.ctrlType = 'Marker'
        _.extend @, IMarker.handle($scope, $element)
      ]

      link:(scope, element, attrs, ctrl) ->
        mapPromise = IMarker.mapPromise(scope, ctrl)

        _singular.link(scope)

        mapPromise.then (map) ->
          gManager = new MarkerManager map

          keys = _.object(IMarker.keys,IMarker.keys)

          child = new MarkerChildModel scope, scope,
            keys, map, {}, doClick = true,
            gManager, doDrawSelf = false,
            trackModel = false

          children = _singular.addChild(scope, child)

          FitHelper.maybeFit(map, children, scope)

          child.deferred.promise.then (gMarker) ->
            scope.deferred.resolve gMarker

          if scope.control?
            scope.control.getGMarkers = gManager.getGMarkers

        scope.$on '$destroy', ->
          gManager?.clear()
          gManager = null
]
