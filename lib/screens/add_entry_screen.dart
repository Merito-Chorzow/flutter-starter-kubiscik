import 'package:flutter/material.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _latText = '';
  String _lngText = '';

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final lat = double.tryParse(_latText);
    final lng = double.tryParse(_lngText);

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Podaj poprawne współrzędne')),
      );
      return;
    }

    final newEntry = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': _title,
      'description': _description,
      'latitude': lat,
      'longitude': lng,
    };

    Navigator.pop(context, newEntry); // zwracamy dane do HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj wpis')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tytuł'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Podaj tytuł' : null,
                onSaved: (v) => _title = v ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Opis'),
                maxLines: 2,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Podaj opis' : null,
                onSaved: (v) => _description = v ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Szerokość (latitude)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Podaj szerokość' : null,
                onSaved: (v) => _latText = v ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Długość (longitude)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Podaj długość' : null,
                onSaved: (v) => _lngText = v ?? '',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: const Text('Zapisz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}