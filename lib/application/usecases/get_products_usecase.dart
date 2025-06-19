import 'package:pry_viveres_rosita/domain/entities/product_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/product_repository.dart'; // Ajusta la ruta

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> call() async {
    return await repository.getProducts();
  }
}