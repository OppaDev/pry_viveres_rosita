import 'environment_config.dart';

class AppConfig {

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
