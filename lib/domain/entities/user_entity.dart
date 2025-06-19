class UserEntity {
  final int id;
  final String name;
  final String email;
  // ... otros campos si son necesarios desde la API (phone, address, etc.)

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}