import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

/// Page with map user interface.
class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.mapPoints});

  /// Points coordinates.
  final List<LatLng> mapPoints;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController _mapController;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Карта заданий')),
    body: FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.mapPoints.first,

        /// Zoom.
        initialZoom: widget.mapPoints.length > 1 ? 10 : 15,
      ),
      children: [
        /// Tiles.
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.geoSurveysApp',
        ),

        /// Markers and clusters.
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            /// Cluster size.
            size: const Size(50, 50),
            maxClusterRadius: 50,
            markers: _getMarkers(widget.mapPoints),
            builder: (context, markers) =>
                _ClusterMarker(markersLength: markers.length.toString()),
          ),
        ),
      ],
    ),
  );
}

/// Markers genaration.
List<Marker> _getMarkers(List<LatLng> mapPoints) => List.generate(
  mapPoints.length,
  (index) => Marker(
    point: mapPoints[index],

    /// Marker size.
    width: 50,
    height: 50,
    alignment: Alignment.center,

    /// Icon and number.
    child: Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.location_on, color: Colors.red, size: 50),
        Positioned(
          bottom: 10,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  ),
);

/// Widget for cluster.
class _ClusterMarker extends StatelessWidget {
  const _ClusterMarker({required this.markersLength});

  /// The number of markers combined into a cluster.
  final String markersLength;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.blue[200],
      shape: BoxShape.circle,
      border: const Border.fromBorderSide(
        BorderSide(color: Colors.blue, width: 3),
      ),
    ),
    child: Center(
      child: Text(
        markersLength,
        style: TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    ),
  );
}
