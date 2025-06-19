import 'environment_config.dart';

class AppConfig {
  // Configuración de la URL base de la API (se toma del entorno actual)
  //
  // IMPORTANTE: Para cambiar la URL, modifica environment_config.dart
  //
  // Para desarrollo local:
  // - Emulador Android: 'http://10.0.2.2:3000/api/v1'
  // - Emulador iOS: 'http://localhost:3000/api/v1'
  // - Dispositivo físico en la misma red Wi-Fi: 'http://TU_IP_LOCAL:3000/api/v1'
  //
  // Para producción:
  // - Servidor real: 'https://tu-dominio.com/api/v1'

  static String get baseUrl => EnvironmentConfig.baseUrl;

  // Otras configuraciones de la app
  static const String appName = 'Viveres Rosita';
  static const String appVersion = '1.0.0';

  // Timeouts para las peticiones HTTP (desde configuración de entorno)
  static Duration get connectionTimeout =>
      Duration(seconds: EnvironmentConfig.connectionTimeout);
  static Duration get receiveTimeout =>
      Duration(seconds: EnvironmentConfig.receiveTimeout);

  // URLs específicas (construidas a partir de baseUrl)
  static String get ordersUrl => '$baseUrl/orders';
  static String get productsUrl => '$baseUrl/products';
  static String get usersUrl => '$baseUrl/users';

  // Configuración de desarrollo vs producción
  static bool get isDebugMode => EnvironmentConfig.isDevelopment;

  // Logging
  static bool get enableHttpLogging => EnvironmentConfig.enableLogging;
}
