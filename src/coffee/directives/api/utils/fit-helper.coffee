angular.module('uiGmapgoogle-maps.directives.api.utils')
.service 'uiGmapFitHelper', [ 'uiGmapLogger', ($log) ->
  @fit = (markersOrPoints, gMap) ->
    if gMap and markersOrPoints?.length
      bounds = new google.maps.LatLngBounds()
      everSet = false
      for key, markerOrPoint of markersOrPoints
        if markerOrPoint
          everSet = true unless everSet
          point = if _.isFunction markerOrPoint.getPosition then markerOrPoint.getPosition() else markerOrPoint
        bounds.extend point
      gMap.fitBounds(bounds) if everSet

  @maybeFit = (map, children, scope) =>
    return if !scope.fit
    return $log.error 'cannot fit if scope is undefined' if !scope
    pathPoints = _.map children, (child) ->
      child.pathPoints.getArray()
    pathPoints = _.flatten pathPoints
    @fit pathPoints, map

  @
]
