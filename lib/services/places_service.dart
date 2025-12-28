import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class PlacesService {
  static Future<List<Place>> fetchNearbyPlaces(
    double lat,
    double lng,
  ) async {
    final query = '''
[out:json];
node(around:1000,$lat,$lng)[amenity];
out;
''';

    final response = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'),
      body: query,
    );

    final data = jsonDecode(response.body);
    final elements = data['elements'] as List;

    return elements
        .where((e) => e['tags']?['name'] != null)
        .map(
          (e) => Place(
            name: e['tags']['name'],
            type: e['tags']['amenity'] ?? 'unknown',
            lat: e['lat'],
            lng: e['lon'],
          ),
        )
        .toList();
  }
}
