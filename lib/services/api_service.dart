import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/journal_entry.dart';

class ApiService {
  static const String _baseUrl =
      'https://jsonplaceholder.typicode.com';

  /// GET — pobierz listę wpisów
  static Future<List<JournalEntry>> fetchEntries() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/posts'));

    if (response.statusCode != 200) {
      throw Exception('Błąd pobierania danych');
    }

    final List data = jsonDecode(response.body);

    return data.take(5).map((json) {
      return JournalEntry(
        id: json['id'].toString(),
        title: json['title'],
        description: json['body'],
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  /// POST — zapisz wpis
  static Future<void> addEntry(JournalEntry entry) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': entry.title,
        'body': entry.description,
        'userId': 1,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Błąd zapisu danych');
    }
  }
}
