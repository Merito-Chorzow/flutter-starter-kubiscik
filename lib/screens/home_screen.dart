import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/api_service.dart';
import 'add_entry_screen.dart';
import 'entry_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> entriesFuture;
  final List<Map<String, dynamic>> _localEntries = [];

  @override
  void initState() {
    super.initState();
    entriesFuture = ApiService().getEntries();
  }

  Future<void> _openAddEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEntryScreen()),
    );

    if (result is Map<String, dynamic>) {
      setState(() {
        _localEntries.add(result); // dodajemy nowy wpis do listy lokalnej
      });
    }
  }

  void _openDetails(Map<String, dynamic> entry) {
    Navigator.pushNamed(
      context,
      '/entryDetail',
      arguments: entry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
        actions: [
          IconButton(
            onPressed: _openAddEntry,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          }

          final apiEntries = snapshot.data ?? [];
          final allEntries = [...apiEntries, ..._localEntries];

          if (allEntries.isEmpty) {
            return const Center(child: Text('Brak wpisów'));
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                apiEntries.isNotEmpty
                    ? apiEntries.first['latitude'] as double
                    : allEntries.first['latitude'] as double,
                apiEntries.isNotEmpty
                    ? apiEntries.first['longitude'] as double
                    : allEntries.first['longitude'] as double,
              ),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: allEntries.map((entry) {
                  final lat = entry['latitude'] as double;
                  final lng = entry['longitude'] as double;

                  return Marker(
                    point: LatLng(lat, lng),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _openDetails(entry),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
