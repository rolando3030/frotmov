import 'package:dio/dio.dart';
import 'session_service.dart';
import '../models/seat.dart';
import '../models/order_result.dart';
import 'session_service.dart';

/// Cliente HTTP centralizado con Dio.
/// - Inyecta el token de acceso si existe (Authorization: Bearer ...).
/// - Expone métodos get/post/put/patch/delete tipados.
/// - Configura timeouts y manejo básico de 401.
class ApiClient {
  final Dio dio;
  final SessionService _session;

  ApiClient._(this.dio, this._session);

  factory ApiClient({
    required SessionService session,
    String? baseUrl,
    Duration connectTimeout = const Duration(seconds: 8),
    Duration receiveTimeout = const Duration(seconds: 8),
    Duration sendTimeout = const Duration(seconds: 8),
  }) {
    final dio = Dio();

    // 👇 IMPORTANTE: para emulador Android usa 10.0.2.2
    final options = BaseOptions(
      baseUrl: baseUrl ?? 'http://10.0.2.2:4567',
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      contentType: 'application/json',
      responseType: ResponseType.json,
      validateStatus: (code) => code != null && code >= 200 && code < 500,
    );

    dio.options = options;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = session.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    return ApiClient._(dio, session);
  }

  // === Helpers HTTP ===
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.get<T>(
      path,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.put<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.patch<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.delete<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }
  // ================= ASIENTOS =================

  Future<Response> getSeats(int showtimeId) {
    return get('/showtimes/$showtimeId/seats');
  }

  // ================= ORDEN / COMPRA =================

  Future<Response> postOrder({
    required int showtimeId,
    required List<int> seatIds,
    required List<Map<String, dynamic>> tickets,
    int? userId,
  }) {
    return post(
      '/orders',
      data: {
        'showtime_id': showtimeId,
        'user_id': userId,
        'seats': seatIds,
        'tickets': tickets,
      },
    );
  }

  Future<Response> confirmOrder(int orderId) {
    return post('/orders/$orderId/confirm');
  }
}
