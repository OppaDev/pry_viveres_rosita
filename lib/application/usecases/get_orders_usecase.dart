import 'package:pry_viveres_rosita/domain/entities/order_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/order_repository.dart'; // Ajusta la ruta

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<List<OrderEntity>> call() async {
    return await repository.getOrders();
  }
}