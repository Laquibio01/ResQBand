import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SafeAreaMap extends StatefulWidget {
  const SafeAreaMap({super.key});

  @override
  State<SafeAreaMap> createState() => _SafeAreaMapState();
}

class _SafeAreaMapState extends State<SafeAreaMap> {
  late final MapController _mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  bool _mapInitialized = false; // Nuevo flag
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

Future<void> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Servicios de ubicación desactivados
    setState(() {
      _errorMessage = 'Activa los servicios de ubicación en tu dispositivo';
    });
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    // Permisos permanentemente denegados
    setState(() {
      _errorMessage = 'Los permisos de ubicación fueron denegados permanentemente. Actívalos manualmente en configuración';
    });
    // Abrir configuración de la app
    await openAppSettings();
    return;
  }

  if (permission == LocationPermission.denied) {
    // Solicitar permisos
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse && 
        permission != LocationPermission.always) {
      setState(() {
        _errorMessage = 'Los permisos de ubicación son necesarios para esta función';
      });
      return;
    }
  }

  // Obtener ubicación
    try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isLoading = false;
      _mapInitialized = true; // Marcamos que el mapa está listo
    });

    // Movemos el mapa solo si está inicializado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mapInitialized && _currentPosition != null) {
        _mapController.move(_currentPosition!, 15);
      }
    });
  } catch (e) {
    setState(() {
      _errorMessage = 'Error al obtener ubicación: ${e.toString()}';
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentPosition ?? const LatLng(0,0),
        initialZoom: 15,
        onMapReady: () {
          if(_currentPosition != null){
            _mapController.move(_currentPosition!, 15);
          }
        }
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.resqband',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentPosition!,
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: _currentPosition!,
              color: Colors.blue.withOpacity(0.3),
              borderColor: Colors.blue,
              borderStrokeWidth: 2,
              radius: 100, // 100 metros
            ),
          ],
        ),
      ],
    );
  }
}