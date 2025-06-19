import 'package:pry_viveres_rosita/domain/entities/user_entity.dart';
import 'package:pry_viveres_rosita/domain/repositories/user_repository.dart';
import 'package:pry_viveres_rosita/data/datasources/remote/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UserEntity>> getUsers() async {
    return await remoteDataSource.getUsers();
  }

  @override
  Future<UserEntity> getUserById(int userId) async {
    return await remoteDataSource.getUserById(userId);
  }
}
