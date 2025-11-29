class Constants {
  // API (preparado para cuando conecten)
  static const String apiBaseUrl = 'http://localhost:8080/api';

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String ventasEndpoint = '/ventas';

  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';

  // Estados de pedido
  static const String estadoPendiente = 'PENDIENTE';
  static const String estadoAceptado = 'ACEPTADO';
  static const String estadoRecogido = 'RECOGIDO';
  static const String estadoEnCamino = 'EN_CAMINO';
  static const String estadoEntregado = 'ENTREGADO';
  static const String estadoCancelado = 'CANCELADO';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);

  // Validation
  static const int minPasswordLength = 6;
}
