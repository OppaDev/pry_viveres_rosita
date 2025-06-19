import 'package:pry_viveres_rosita/domain/entities/order_item_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/order_repository.dart'; // Ajusta la ruta

class AddOrderItemUseCase {
  final OrderRepository repository;

  AddOrderItemUseCase(this.repository);

  Future<OrderItemEntity> call({required String orderId, required int productId, required int quantity}) async {
    return await repository.addOrderItemToOrder(orderId: orderId, productId: productId, quantity: quantity);
  }
}