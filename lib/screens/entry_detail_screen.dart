import 'package:flutter/material.dart';

class EntryDetailScreen extends StatelessWidget {
  const EntryDetailScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Getting the passed entry data
    final entry = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry['title'] ?? 'Szczegóły'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry['description'] ?? 'Brak opisu',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Data: ${entry['date'] ?? 'Nieznana'}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            // If entry has a photo, display it
            entry['photoUrl'] != null 
              ? Image.network(entry['photoUrl']) 
              : Container(),
            SizedBox(height: 16),
            // If entry has location data, show a map or address
            entry['location'] != null
              ? Text('Lokalizacja: ${entry['location']}')
              : Container(),
          ],
        ),
      ),
    );
  }
}
