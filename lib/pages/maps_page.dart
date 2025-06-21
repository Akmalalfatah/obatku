import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class Pharmacy {
  final String name;
  final LatLng position;
  final double distance;

  Pharmacy({
    required this.name,
    required this.position,
    required this.distance,
  });
}

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  LatLng? _currentLocation;
  bool _isLoading = true;
  String _error = '';
  List<Pharmacy> _pharmacies = [];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _error = 'Permission denied');
          return;
        }
      }

      Position pos = await Geolocator.getCurrentPosition();
      _currentLocation = LatLng(pos.latitude, pos.longitude);
      _loadPharmacies();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _loadPharmacies() async {
    if (_currentLocation == null) return;

    final url =
        'https://overpass-api.de/api/interpreter?data=[out:json];node["amenity"="pharmacy"](around:10000,${_currentLocation!.latitude},${_currentLocation!.longitude});out;';

    try {
      final res = await http.get(Uri.parse(url));
      final result = await compute(parsePharmacyData, {
        'body': res.body,
        'lat': _currentLocation!.latitude,
        'lon': _currentLocation!.longitude,
      });

      if (mounted) {
        setState(() {
          _pharmacies = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  static List<Pharmacy> parsePharmacyData(Map<String, dynamic> args) {
    final data = jsonDecode(args['body']);
    final center = LatLng(args['lat'], args['lon']);
    final Distance dist = Distance();
    final List<Pharmacy> pharmacies = [];

    for (var e in data['elements']) {
      final lat = e['lat'];
      final lon = e['lon'];
      final name = e['tags']?['name'] ?? 'Apotek';
      final d = dist.as(LengthUnit.Kilometer, center, LatLng(lat, lon));
      if (d <= 10) {
        pharmacies.add(
          Pharmacy(name: name, position: LatLng(lat, lon), distance: d),
        );
      }
    }
    pharmacies.sort((a, b) => a.distance.compareTo(b.distance));
    return pharmacies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          _currentLocation != null ? _buildMapView() : SizedBox(),
          if (_isLoading) Center(child: CircularProgressIndicator()),
          if (_error.isNotEmpty)
            Center(
              child: Text(
                'Error: $_error',
                style: TextStyle(color: Colors.red),
              ),
            ),
          Positioned(top: 20, left: 20, right: 20, child: _buildSearchBar()),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildPharmacyPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return FlutterMap(
      options: MapOptions(initialCenter: _currentLocation!, initialZoom: 13.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: "com.example.obatku",
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentLocation!,
              width: 40,
              height: 40,
              child: Icon(Icons.my_location, color: Colors.blue),
            ),
            for (var p in _pharmacies.take(20))
              Marker(
                point: p.position,
                width: 50,
                height: 50,
                child: Icon(Icons.local_pharmacy, color: Colors.deepPurple),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search....',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.settings, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPharmacyPanel() {
    return Container(
      height: 350,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E5FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apotek Near You',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _pharmacies.length > 5 ? 5 : _pharmacies.length,
              itemBuilder: (context, index) {
                final p = _pharmacies[index];
                final isOpen = p.name.toLowerCase().contains('24');
                return Card(
                  margin: EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_pin,
                      color: Colors.black,
                      size: 28,
                    ),
                    title: Text(p.name),
                    subtitle: Text(
                      '${p.distance.toStringAsFixed(2)} km dari lokasi',
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isOpen ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        isOpen ? 'Buka 24 Jam' : 'Tidak Buka',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
