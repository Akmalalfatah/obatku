import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show Distance, LatLng, LengthUnit;
import 'package:http/http.dart' as http;

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
  final LatLng _defaultLocation = LatLng(-6.2922, 106.7982);
  bool _isLoading = true;
  String _error = '';
  List<Pharmacy> _pharmacies = [];

  @override
  void initState() {
    super.initState();
    _loadPharmacies();
  }

  Future<void> _loadPharmacies() async {
    final url =
        'https://overpass-api.de/api/interpreter?data=[out:json];'
        'node["amenity"="pharmacy"]'
        '(around:10000,${_defaultLocation.latitude},${_defaultLocation.longitude});out;';
    try {
      final res = await http.get(Uri.parse(url));
      final data = jsonDecode(res.body);
      final Distance dist = Distance();
      final List<Pharmacy> list = [];

      for (var e in data['elements']) {
        final lat = e['lat'];
        final lon = e['lon'];
        final name = e['tags']?['name'] ?? 'Apotek';
        final d = dist.as(
          LengthUnit.Kilometer,
          _defaultLocation,
          LatLng(lat, lon),
        );

        if (d <= 10) {
          list.add(
            Pharmacy(name: name, position: LatLng(lat, lon), distance: d),
          );
        }
      }

      list.sort((a, b) => a.distance.compareTo(b.distance));

      if (mounted) {
        setState(() {
          _pharmacies = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          _buildMapView(),
          Positioned(top: 20, left: 20, right: 20, child: _buildSearchBar()),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildPharmacyPanel(),
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
          if (_error.isNotEmpty)
            Center(
              child: Text(
                'Error: $_error',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return FlutterMap(
      options: MapOptions(initialCenter: _defaultLocation, initialZoom: 13.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: "com.example.obatku",
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _defaultLocation,
              width: 40,
              height: 40,
              child: Icon(Icons.my_location, color: Colors.blue),
            ),
            for (var p in _pharmacies)
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
