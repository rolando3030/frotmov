// lib/services/session_service.dart

/// Servicio sencillo para manejar la sesión del usuario:
/// - token de acceso (JWT)
/// - id de usuario
///
/// Se implementa como SINGLETON:
///  - Puedes usar `SessionService()`
///  - O `SessionService.instance`
class SessionService {
  // ---------- Singleton ----------
  SessionService._internal();

  static final SessionService _singleton = SessionService._internal();

  // Constructor público usado en main.dart -> SessionService()
  factory SessionService() => _singleton;

  // Acceso estático usado en otras partes -> SessionService.instance
  static SessionService get instance => _singleton;

  // ---------- Estado de sesión ----------
  String? _accessToken;
  int? _userId;

  String? get accessToken => _accessToken;
  int? get userId => _userId;

  /// Guardar/actualizar datos de sesión
  void setSession({
    String? token,
    int? userId,
  }) {
    _accessToken = token ?? _accessToken;
    _userId = userId ?? _userId;
  }

  /// Limpiar sesión (logout)
  void clear() {
    _accessToken = null;
    _userId = null;
  }
}
