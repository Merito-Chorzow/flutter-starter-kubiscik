import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/journal_entry.dart';
import '../services/location_service.dart';
import '../services/api_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Position? _position;
  bool _isSaving = false;

  /// 
  /// ZAPIS WPISU
  //
  Future<void> _saveEntry() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tytuł jest wymagany'),
        ),
      );
      return;
    }

    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Najpierw pobierz lokalizację'),
        ),
      );
      return;
    }

    final entry = JournalEntry(
      id: DateTime.now().toIso8601String(),
      title: _titleController.text,
      description: _descriptionController.text,
      createdAt: DateTime.now(),
      latitude: _position!.latitude,
      longitude: _position!.longitude,
    );

    setState(() => _isSaving = true);

    try {
      await ApiService.addEntry(entry);
      if (mounted) {
        Navigator.pop(context, entry);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd zapisu: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  ////
  /// UI
  /// 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj wpis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isSaving ? null : _saveEntry,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// TYTUŁ
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            const SizedBox(height: 16),

            /// OPIS
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Opis'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            /// 
            /// POBIERZ LOKALIZACJĘ
            /// 
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Pobierz lokalizację'),
              onPressed: () async {
                ///  BLOKADA – brak tytułu
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Najpierw wpisz tytuł'),
                    ),
                  );
                  return;
                }

                final pos =
                    await LocationService.getCurrentLocation();

                if (pos == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Brak dostępu do lokalizacji'),
                    ),
                  );
                  return;
                }

                setState(() {
                  _position = pos;
                });
              },
            ),

            /// 
            /// WYŚWIETLENIE GPS
            /// 
            if (_position != null) ...[
              const SizedBox(height: 12),
              Text(
                'Lat: ${_position!.latitude}\nLng: ${_position!.longitude}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Kliknij ✔ aby zapisać wpis',
                style: TextStyle(color: Colors.grey),
              ),
            ],

            if (_isSaving) ...[
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
