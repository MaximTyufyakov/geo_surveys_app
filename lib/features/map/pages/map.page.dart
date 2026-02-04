import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;

  List<LatLng> get _mapPoints => const [
    LatLng(55.755793, 37.617134),
    LatLng(55.095960, 38.765519),
    LatLng(56.129038, 40.406502),
    LatLng(54.513645, 36.261268),
    LatLng(54.193122, 37.617177),
    LatLng(54.629540, 39.741809),
  ];

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
    appBar: AppBar(title: const Text('Map Screen')),
    body: FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(55.755793, 37.617134),
        initialZoom: 5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.geoSurveysApp',
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            size: const Size(50, 50),
            maxClusterRadius: 50,
            markers: _getMarkers(_mapPoints),
            builder: (_, markers) =>
                _ClusterMarker(markersLength: markers.length.toString()),
          ),
        ),
      ],
    ),
  );
}

/// Метод генерации маркеров
/// Метод генерации маркеров
List<Marker> _getMarkers(List<LatLng> mapPoints) => List.generate(
  mapPoints.length,
  (index) => Marker(
    point: mapPoints[index],
    width: 50,
    height: 50,
    alignment: Alignment.center,
    child: Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.location_on, color: Colors.red, size: 50),
        Positioned(
          bottom: 10, // Настройте позиционирование под ваш дизайн
          child: Text(
            '${index + 1}', // Номер с 1
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

/// Виджет для отображения кластера
class _ClusterMarker extends StatelessWidget {
  const _ClusterMarker({required this.markersLength});

  /// Количество маркеров, объединенных в кластер
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
