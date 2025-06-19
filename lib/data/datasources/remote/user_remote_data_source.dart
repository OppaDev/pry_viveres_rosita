import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pry_viveres_rosita/domain/entities/user_entity.dart';
import 'package:pry_viveres_rosita/core/config/app_config.dart';

abstract class UserRemoteDataSource {
  Future<List<UserEntity>> getUsers();
  Future<UserEntity> getUserById(int userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserEntity>> getUsers() async {
    final response = await client.get(Uri.parse(AppConfig.usersUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => UserEntity.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<UserEntity> getUserById(int userId) async {
    final response = await client.get(
      Uri.parse('${AppConfig.usersUrl}/$userId'),
    );
    if (response.statusCode == 200) {
      return UserEntity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}
