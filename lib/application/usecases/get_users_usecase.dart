import 'package:pry_viveres_rosita/domain/entities/user_entity.dart';
import 'package:pry_viveres_rosita/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserEntity>> call() async {
    return await repository.getUsers();
  }
}

class GetUserByIdUseCase {
  final UserRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<UserEntity> call(int userId) async {
    return await repository.getUserById(userId);
  }
}
