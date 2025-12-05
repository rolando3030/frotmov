class DulceriaItem {
  final int id;
  final String name;
  final String imagePath;
  final double price;
  final String category;

  DulceriaItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.category,
  });

  factory DulceriaItem.fromJson(Map<String, dynamic> json) {
    return DulceriaItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imagePath: json['image_path'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
    );
  }
}
