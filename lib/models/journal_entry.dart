class JournalEntry {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  final double? latitude;
  final double? longitude;

  
  final String? placeName;

  JournalEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.placeName,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      placeName: json['placeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'placeName': placeName,
    };
  }
}
