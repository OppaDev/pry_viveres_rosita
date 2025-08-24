/// Enum para definir diferentes entornos de la aplicación
enum Environment { development, staging, production }

/// Configuración específica por entorno
class EnvironmentConfig {
  static const Environment currentEnvironment = Environment.development;

  /// Configuración para diferentes entornos
  static const Map<Environment, Map<String, dynamic>> _config = {
    Environment.development: {
      'baseUrl': 'http://10.40.13.25:3000/api/v1', // Actualiza con tu IP local
      'enableLogging': true,
      'connectionTimeout': 10, // Reducido para desarrollo local
      'receiveTimeout': 15, // Reducido para mejorar respuesta
    },
    Environment.staging: {
      'baseUrl': 'https://staging-api.viveresrosita.com/api/v1',
      'enableLogging': true,
      'connectionTimeout': 20, // Reducido para staging
      'receiveTimeout': 25, // Reducido para staging
    },
    Environment.production: {
      'baseUrl': 'https://api.viveresrosita.com/api/v1',
      'enableLogging': false,
      'connectionTimeout': 10, // Más agresivo para producción
      'receiveTimeout': 15, // Más agresivo para producción
    },
  };

  /// Obtener configuración del entorno actual
  static Map<String, dynamic> get config => _config[currentEnvironment]!;

  /// Getters específicos para valores comunes
  static String get baseUrl => config['baseUrl'] as String;
  static bool get enableLogging => config['enableLogging'] as bool;
  static int get connectionTimeout => config['connectionTimeout'] as int;
  static int get receiveTimeout => config['receiveTimeout'] as int;

  /// Verificar si estamos en desarrollo
  static bool get isDevelopment =>
      currentEnvironment == Environment.development;
  static bool get isProduction => currentEnvironment == Environment.production;
}
