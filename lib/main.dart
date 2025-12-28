import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'models/journal_entry.dart';
import 'screens/entry_details_screen.dart';
import 'services/location_service.dart';

void main() {
  runApp(const GeoJournalApp());
}

class GeoJournalApp extends StatelessWidget {
  const GeoJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const EntriesListScreen(),
    );
  }
}

/// 
/// LISTA WPISÓW
///
class EntriesListScreen extends StatefulWidget {
  const EntriesListScreen({super.key});

  @override
  State<EntriesListScreen> createState() => _EntriesListScreenState();
}

class _EntriesListScreenState extends State<EntriesListScreen> {
  final List<JournalEntry> _entries = [];

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geo Journal')),
      body: _entries.isEmpty
          ? const Center(child: Text('Brak wpisów'))
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final e = _entries[index];
                return ListTile(
                  title: Text(e.title),
                  subtitle: Text(_formatDate(e.createdAt)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EntryDetailsScreen(entry: e),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final entry = await Navigator.push<JournalEntry>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEntryScreen(),
            ),
          );

          
          if (entry != null) {
            setState(() {
              _entries.insert(0, entry);
            });
          }
        },
      ),
    );
  }
}

///
/// DODAJ WPIS
/// 
class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  Position? _position;

  bool get canSave =>
      _titleCtrl.text.trim().isNotEmpty && _position != null;

  Future<void> _getLocation() async {
    final pos = await LocationService.getCurrentLocation();
    if (pos == null) return;
    setState(() => _position = pos);
  }

  void _save() {
    if (!canSave) return;

    final entry = JournalEntry(
      id: DateTime.now().toIso8601String(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      createdAt: DateTime.now(),
      latitude: _position!.latitude,
      longitude: _position!.longitude,
    );

    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj wpis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: canSave ? _save : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Tytuł'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Opis'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Pobierz lokalizację'),
              onPressed: _titleCtrl.text.isEmpty ? null : _getLocation,
            ),
            if (_position != null) ...[
              const SizedBox(height: 12),
              Text(
                'Lat: ${_position!.latitude}\nLng: ${_position!.longitude}',
                textAlign: TextAlign.center,
              ),
              const Text('Kliknij ✔ aby zapisać'),
            ],
          ],
        ),
      ),
    );
  }
}
