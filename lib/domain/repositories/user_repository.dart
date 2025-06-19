import 'package:pry_viveres_rosita/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsers();
  Future<UserEntity> getUserById(int userId);
}
