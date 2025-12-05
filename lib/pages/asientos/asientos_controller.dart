// lib/pages/asientos/asientos_controller.dart
import 'package:dio/dio.dart';

import '../../models/seat.dart';
import '../../services/api_client.dart';
import '../../services/session_service.dart';

class AsientosController {
  final ApiClient _api;

  AsientosController(SessionService session)
      : _api = ApiClient(session: session);

  Future<List<Seat>> getSeatsForShowtime(int showtimeId) async {
    final Response res = await _api.getSeats(showtimeId);
    final data = res.data as Map<String, dynamic>;
    final List<dynamic> seatsJson = data['seats'] as List<dynamic>;

    return seatsJson
        .map((e) => Seat.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
