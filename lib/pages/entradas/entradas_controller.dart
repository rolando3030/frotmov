// lib/pages/entradas/entradas_controller.dart
import 'package:dio/dio.dart';

import '../../models/order_result.dart';
import '../../services/api_client.dart';
import '../../services/session_service.dart';

class EntradasController {
  final ApiClient _api;

  EntradasController(SessionService session)
      : _api = ApiClient(session: session);

  Future<OrderResult> crearOrden({
    required int showtimeId,
    required List<int> seatIds,
    required List<Map<String, dynamic>> tickets,
    int? userId,
  }) async {
    final Response res = await _api.postOrder(
      showtimeId: showtimeId,
      seatIds: seatIds,
      tickets: tickets,
      userId: userId,
    );

    final data = res.data as Map<String, dynamic>;
    return OrderResult.fromJson(data);
  }

  Future<void> confirmarOrden(int orderId) async {
    await _api.confirmOrder(orderId);
  }
}
