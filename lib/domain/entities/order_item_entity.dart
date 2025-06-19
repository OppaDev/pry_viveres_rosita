import 'package:pry_viveres_rosita/domain/entities/product_entity.dart'; // Ajusta la ruta

class OrderItemEntity {
  final int? id; // El ID es opcional al crear, la API lo genera
  final int productId;
  final int quantity;
  final double unitPrice; // Almacenado en la API
  final ProductEntity? product; // Para mostrar detalles del producto

  OrderItemEntity({
    this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.product,
  });

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) {
    return OrderItemEntity(
      id: json['id'],
      productId: json['product_id'] ?? json['productId'],
      quantity: json['quantity'],
      unitPrice: double.parse(json['unitPrice']?.toString() ?? json['unit_price']?.toString() ?? '0.0'),
      product: json['product'] != null
          ? ProductEntity.fromJson(json['product'])
          : null,
    );
  }

  // Para enviar a la API al crear/agregar items.
  // El backend calculará/asignará el unitPrice basado en el productId.
  Map<String, dynamic> toJsonForRequest() => {
    'productId': productId,
    'quantity': quantity,
  };
}