class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}
