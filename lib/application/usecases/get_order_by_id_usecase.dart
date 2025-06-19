import 'package:pry_viveres_rosita/domain/entities/order_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/order_repository.dart'; // Ajusta la ruta

class GetOrderByIdUseCase {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  Future<OrderEntity> call(String orderId) async {
    return await repository.getOrderById(orderId);
  }
}