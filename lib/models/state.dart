class StateModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  StateModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}
