import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pry_viveres_rosita/domain/entities/product_entity.dart'; // Ajusta la ruta

abstract class ProductRemoteDataSource {
  Future<List<ProductEntity>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final String _baseUrl = 'http://YOUR_API_IP:3000/api/v1'; // CAMBIAR ESTO

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductEntity>> getProducts() async {
    final response = await client.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => ProductEntity.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}