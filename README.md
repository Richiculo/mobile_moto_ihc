# CambaEats Conductor (Mobile)

## Arquitectura usada
- **Flutter** (Dart)
- Arquitectura simple: sin Provider, sin MVVM, sin login
- Navegación directa: selector de conductor → pantalla principal
- Integración con backend NestJS vía HTTP
- Uso de Google Maps y Geolocator para ubicación en tiempo real

## ¿Cómo correr la app?
1. **Requisitos previos:**
   - Tener Flutter instalado ([guía oficial](https://docs.flutter.dev/get-started/install))
   - Android Studio o emulador/dispositivo físico
   - Google Maps API Key configurada en `android/app/src/main/AndroidManifest.xml`
2. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```
3. **Ejecutar en dispositivo/emulador:**
   ```bash
   flutter run
   ```

## Funcionalidades mínimas actuales
- Selector de conductor (Tachero 1 / Tachero 2)
- Mapa en tiempo real con ubicación del conductor (soporta Fake GPS)
- Polling automático para recibir pedidos asignados
- Alerta de nuevo pedido con opción de aceptar o rechazar
- Flujo completo: aceptar, iniciar viaje, entregar
- Reasignación automática si un conductor rechaza
- Actualización de ubicación al backend cada 5 segundos

---

> Proyecto MVP para la demo de CambaEats. Código limpio, sin pantallas ni lógica innecesaria. Solo lo esencial para el flujo de conductores.
