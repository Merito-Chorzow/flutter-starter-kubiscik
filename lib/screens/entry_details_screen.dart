import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class EntryDetailsScreen extends StatelessWidget {
  final JournalEntry entry;

  const EntryDetailsScreen({
    super.key,
    required this.entry,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///  NAZWA MIEJSCA
            if (entry.placeName != null) ...[
              Text(
                entry.placeName!,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
            ],

            ///  OPIS
            Text(
              entry.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            ///  DATA
            Text(
              'Utworzono: ${_formatDate(entry.createdAt)}',
              style: const TextStyle(color: Colors.grey),
            ),

            ///  WSPÓŁRZĘDNE 
            if (entry.latitude != null && entry.longitude != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Lokalizacja GPS:\n'
                'Lat: ${entry.latitude}\n'
                'Lng: ${entry.longitude}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
