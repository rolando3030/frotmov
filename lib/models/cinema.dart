class Cinema {
  final int id;
  final String name;
  final String address;
  final int cityId;

  Cinema({
    required this.id,
    required this.name,
    required this.address,
    required this.cityId,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      cityId: json['city_id'] ?? 0,
    );
  }
}
