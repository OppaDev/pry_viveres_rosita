import 'package:pry_viveres_rosita/data/datasources/remote/product_remote_data_source.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/entities/product_entity.dart'; // Ajusta la ruta
import 'package:pry_viveres_rosita/domain/repositories/product_repository.dart'; // Ajusta la ruta

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getProducts() async {
    return await remoteDataSource.getProducts();
  }
}