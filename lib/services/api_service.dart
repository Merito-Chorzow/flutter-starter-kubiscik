class ApiService {
  Future<List<Map<String, dynamic>>> getEntries() async {
    await Future.delayed (const Duration(seconds:1));

    return [
      {
      'id':1,
      'title': 'Uczelnia',
      'description': 'Budynek, w którym mam zajęcia.',
      'latitude': 50.297,
      'longitude': 18.955,
      },
      {
        'id':2,
        'title': 'Dom',
        'description': 'Miejsce, gdzie mieszkam.',
        'latitude': 50.30,
        'longitude': 18.96,
      },
    ];
  }
}