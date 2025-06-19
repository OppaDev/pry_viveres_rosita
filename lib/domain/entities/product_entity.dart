class ProductEntity {
  final int id;
  final String name;
  final String description;
  final double price; // En la API es DECIMAL, en Dart usamos double
  final int stock;
  final String image;
  final int categoryId;
  // final DateTime createdAt; // Opcional si no lo necesitas en UI directamente

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.categoryId,
    // required this.createdAt,
  });

  // fromJson para conveniencia, aunque técnicamente podría estar en el modelo de la capa de datos
  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()), // Asegurar conversión
      stock: json['stock'],
      image: json['image'],
      categoryId: json['category_id'] ?? json['categoryId'], // API usa category_id o categoryId
      // createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'image': image,
        'category_id': categoryId,
        // 'created_at': createdAt.toIso8601String(),
      };
}