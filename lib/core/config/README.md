# Configuración de la Aplicación

Este directorio contiene toda la configuración centralizada de la aplicación Viveres Rosita.

## Archivos de Configuración

### 1. `app_config.dart`
Contiene la configuración principal de la aplicación, incluyendo:
- URLs de los endpoints de la API
- Configuración de timeouts para peticiones HTTP
- Información general de la app (nombre, versión)
- Configuraciones de debug y logging

### 2. `environment_config.dart`
Maneja la configuración por entornos (desarrollo, staging, producción):
- URLs base diferentes según el entorno
- Configuraciones específicas por entorno
- Control del entorno actual de la aplicación

## Uso

### Cambiar la URL de la API

Para cambiar la URL de tu API, sigue estos pasos:

1. **Abre `environment_config.dart`**
2. **Modifica la URL en la configuración de desarrollo:**

```dart
Environment.development: {
  'baseUrl': 'http://TU_IP_LOCAL:3000/api/v1', // Cambia por tu IP
  // ... resto de configuración
},
```

### URLs comunes según tu setup:

**Para Emulador Android:**
```dart
'baseUrl': 'http://10.0.2.2:3000/api/v1'
```

**Para Emulador iOS:**
```dart
'baseUrl': 'http://localhost:3000/api/v1'
```

**Para Dispositivo Físico (misma red Wi-Fi):**
```dart
'baseUrl': 'http://192.168.X.X:3000/api/v1' // Tu IP local
```

**Para Servidor en la Nube:**
```dart
'baseUrl': 'https://tu-dominio.com/api/v1'
```

### Cambiar de Entorno

Para cambiar entre entornos, modifica la constante en `environment_config.dart`:

```dart
static const Environment currentEnvironment = Environment.development; // o staging, production
```

## Estructura de URLs

La aplicación construye automáticamente las URLs específicas:

- **Pedidos**: `{baseUrl}/orders`
- **Productos**: `{baseUrl}/products`
- **Usuarios**: `{baseUrl}/users`

## Configuraciones por Entorno

### Desarrollo
- Logging habilitado
- Timeouts más largos (30 segundos)
- URL local o de desarrollo

### Staging
- Logging habilitado
- Timeouts normales (30 segundos)
- URL del servidor de staging

### Producción
- Logging deshabilitado
- Timeouts más cortos (15 segundos)
- URL del servidor de producción

## Usar en tu Código

```dart
import 'package:pry_viveres_rosita/core/config/app_config.dart';

// Obtener la URL base
String apiUrl = AppConfig.baseUrl;

// Obtener URLs específicas
String ordersUrl = AppConfig.ordersUrl;
String productsUrl = AppConfig.productsUrl;

// Verificar si estamos en modo debug
if (AppConfig.isDebugMode) {
  print('Ejecutando en modo desarrollo');
}
```

## Beneficios

✅ **Configuración centralizada**: Todas las URLs en un solo lugar
✅ **Consistencia**: Misma URL base para todos los data sources
✅ **Flexibilidad**: Fácil cambio entre entornos
✅ **Mantenimiento**: Cambios centralizados
✅ **Escalabilidad**: Preparado para múltiples entornos
