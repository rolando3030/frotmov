// lib/services/auth_repository.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ==== CONFIG: backend Ruby ====
/// En EMULADOR ANDROID, 10.0.2.2 apunta a la PC host (donde corre ruby app.rb)
const String kBaseUrl = 'http://10.0.2.2:4567';

/// ==== ERRORES DE AUT ====
class AuthError implements Exception {
  final String message;
  AuthError(this.message);
  @override
  String toString() => message;
}

/// ==== MODELOS SIMPLES ====

class User {
  final int id;
  final String nombre;
  final String apellido;
  final String correo;
  final String? telefono;

  User({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    this.telefono,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
        id: j['id'] as int,
        nombre: (j['nombre'] ?? '') as String,
        apellido: (j['apellido'] ?? '') as String,
        correo: (j['correo'] ?? '') as String,
        telefono: j['telefono'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'correo': correo,
        if (telefono != null) 'telefono': telefono,
      };
}

class Tokens {
  final String access; // JWT
  final int? expiresAt; // epoch seconds (opcional)

  Tokens({required this.access, this.expiresAt});

  factory Tokens.fromJson(Map<String, dynamic> j) => Tokens(
        access: (j['access'] ?? '') as String,
        expiresAt: (j['expiresAt'] is int) ? j['expiresAt'] as int : null,
      );

  Map<String, dynamic> toJson() => {
        'access': access,
        if (expiresAt != null) 'expiresAt': expiresAt,
      };
}

class AuthResult {
  final User user;
  final Tokens tokens;
  AuthResult({required this.user, required this.tokens});
}

/// ==== REPOSITORIO ====

class AuthRepository {
  final Dio _dio;
  String? _token; // en memoria

  AuthRepository._(this._dio);

  /// Crea instancia con baseUrl + interceptor Authorization
  static Future<AuthRepository> create() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final repo = AuthRepository._(dio);
    await repo._loadSessionFromStorage();

    // Interceptor para enviar Authorization si hay token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (repo._token != null && repo._token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${repo._token}';
          }
          handler.next(options);
        },
      ),
    );

    return repo;
  }

  /// ========= UTILIDADES DE SESIÓN =========

  static const _kTokenKey = 'auth_token';
  static const _kUserKey = 'auth_user';

  Future<void> _loadSessionFromStorage() async {
    final sp = await SharedPreferences.getInstance();
    _token = sp.getString(_kTokenKey);
    // No cargamos el user aquí porque los controladores no lo necesitan aún.
  }

  Future<void> _saveSession({
    required User user,
    required Tokens tokens,
  }) async {
    final sp = await SharedPreferences.getInstance();
    _token = tokens.access;
    await sp.setString(_kTokenKey, tokens.access);
    await sp.setString(_kUserKey, jsonEncode(user.toJson()));
  }

  Future<void> clearSession() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kTokenKey);
    await sp.remove(_kUserKey);
    _token = null;
  }

  Future<User?> currentUser() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(_kUserKey);
    if (s == null) return null;
    try {
      return User.fromJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  String? get currentToken => _token;

  /// ========= HEALTHCHECK (opcional) =========
  Future<bool> health() async {
    try {
      final r = await _dio.get('/health');
      return (r.data is Map) ? (r.data['ok'] == true) : false;
    } catch (_) {
      return false;
    }
  }

  /// ========= 1) SIGN-IN =========
  ///
  /// Backend: POST /auth/sign-in
  /// body: { correo, password }
  /// resp: { user: {...}, tokens: { access, expiresAt? } }
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final r = await _dio.post(
        '/auth/sign-in',
        data: {'correo': email, 'password': password},
      );

      final data = r.data as Map<String, dynamic>;
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      final tokens = Tokens.fromJson(data['tokens'] as Map<String, dynamic>);

      await _saveSession(user: user, tokens: tokens);
      return AuthResult(user: user, tokens: tokens);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 401) {
        throw AuthError('Usuario o contraseña incorrectos');
      }
      if (code == 422) {
        throw AuthError('Faltan datos');
      }
      throw AuthError('No se pudo iniciar sesión');
    } catch (_) {
      throw AuthError('No se pudo iniciar sesión');
    }
  }

  /// ========= 2) SIGN-UP =========
  ///
  /// Backend: POST /auth/sign-up
  /// body: { nombre, apellido, correo, telefono?, password }
  /// resp: { user: {...}, tokens: { access, expiresAt? } }
  Future<AuthResult> signUp({
    required String nombre,
    required String apellido,
    required String email,
    String? telefono,
    required String password,
  }) async {
    try {
      final r = await _dio.post(
        '/auth/sign-up',
        data: {
          'nombre': nombre,
          'apellido': apellido,
          'correo': email,
          if (telefono != null && telefono.isNotEmpty) 'telefono': telefono,
          'password': password,
        },
      );

      final data = r.data as Map<String, dynamic>;
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      final tokens = Tokens.fromJson(data['tokens'] as Map<String, dynamic>);

      // Si el backend devuelve token, guardamos sesión; si no, guardamos user sin token
      if (tokens.access.isNotEmpty) {
        await _saveSession(user: user, tokens: tokens);
      } else {
        // Guardar al menos el user (sin token) por si lo quieres usar
        final sp = await SharedPreferences.getInstance();
        await sp.setString(_kUserKey, jsonEncode(user.toJson()));
      }

      return AuthResult(user: user, tokens: tokens);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 409) {
        throw AuthError('El correo ya está registrado');
      }
      if (code == 422) {
        throw AuthError('Faltan datos');
      }
      throw AuthError('No se pudo registrar');
    } catch (_) {
      throw AuthError('No se pudo registrar');
    }
  }

  /// ========= 3) RESET-PASSWORD (REQUEST) =========
  ///
  /// Backend: POST /auth/reset-password
  /// body: { correo }
  /// resp (dev): { ok: true, reset_token: "xxxx" }  (en prod usualmente solo { ok: true })
  /// Retorna el token si viene (útil en dev), o null.
  Future<String?> resetPasswordRequest({required String email}) async {
    try {
      final r = await _dio.post(
        '/auth/reset-password',
        data: {'correo': email},
      );
      if (r.data is Map && r.data['reset_token'] is String) {
        return r.data['reset_token'] as String;
      }
      return null;
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 422) {
        throw AuthError('Falta correo');
      }
      throw AuthError('No se pudo enviar el código');
    } catch (_) {
      throw AuthError('No se pudo enviar el código');
    }
  }

  /// ========= 4) CONFIRM-PASSWORD =========
  ///
  /// Backend: PUT /auth/confirm-password
  /// body: { token, new_password }
  /// resp: { ok: true }
  Future<void> resetPasswordConfirm({
    required String
        email, // (no lo usa el backend, pero lo pasamos por conveniencia en app)
    required String token,
    required String newPassword,
  }) async {
    try {
      await _dio.put(
        '/auth/confirm-password',
        data: {
          'token': token,
          'new_password': newPassword,
        },
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 400) {
        final msg =
            e.response?.data is Map ? (e.response?.data['error'] ?? '') : '';
        if ((msg as String).toLowerCase().contains('expir')) {
          throw AuthError('El código expiró. Solicita uno nuevo.');
        }
        throw AuthError('Código inválido o usado.');
      }
      if (code == 422) {
        throw AuthError('Faltan datos');
      }
      throw AuthError('No se pudo actualizar la contraseña');
    } catch (_) {
      throw AuthError('No se pudo actualizar la contraseña');
    }
  }

  /// ========= SIGN-OUT (limpia sesión local) =========
  Future<void> signOut() async => clearSession();
}
