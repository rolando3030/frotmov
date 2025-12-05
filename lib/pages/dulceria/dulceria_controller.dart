// lib/pages/dulceria/dulceria_controller.dart
import 'package:get/get.dart';

import '../../models/dulceria.dart';
import '../../models/order_result.dart';
import '../../services/api_client.dart';
import '../../services/session_service.dart';

class DulceriaController extends GetxController {
  final isLoading = false.obs;
  final error = RxnString();
  final items = <DulceriaItem>[].obs;

  /// idProducto -> cantidad
  final quantities = <int, int>{}.obs;

  /// Total en soles
  final total = 0.0.obs;

  final ApiClient _api;

  DulceriaController() : _api = ApiClient(session: SessionService.instance);

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _api.get('/dulceria_items');
      final data = response.data as List<dynamic>;

      final loaded = data
          .map((e) => DulceriaItem.fromJson(e as Map<String, dynamic>))
          .toList();

      items.assignAll(loaded);
      _recalculateTotal();
    } catch (e) {
      error.value = 'Error al cargar dulcería: $e';
    } finally {
      isLoading.value = false;
    }
  }

  int getQty(int itemId) => quantities[itemId] ?? 0;

  void increase(DulceriaItem item) {
    final current = quantities[item.id] ?? 0;
    quantities[item.id] = current + 1;
    quantities.refresh();
    _recalculateTotal();
  }

  void decrease(DulceriaItem item) {
    final current = quantities[item.id] ?? 0;
    if (current <= 0) return;

    final newValue = current - 1;
    if (newValue <= 0) {
      quantities.remove(item.id);
    } else {
      quantities[item.id] = newValue;
    }
    quantities.refresh();
    _recalculateTotal();
  }

  void _recalculateTotal() {
    double sum = 0;
    for (final item in items) {
      final qty = quantities[item.id] ?? 0;
      if (qty > 0) {
        sum += item.price * qty;
      }
    }
    total.value = sum;
  }

  /// Crea una orden SOLO de dulcería en /orders
  Future<OrderResult> crearOrdenDulceria() async {
    final snacks = <Map<String, dynamic>>[];

    for (final item in items) {
      final qty = quantities[item.id] ?? 0;
      if (qty > 0) {
        snacks.add({
          'item_id': item.id,
          'name': item.name,
          'qty': qty,
          'price': item.price,
        });
      }
    }

    if (snacks.isEmpty) {
      throw Exception('No hay productos seleccionados');
    }

    final resp = await _api.post(
      '/orders',
      data: {
        'showtime_id': null,
        'seat_ids': [],
        'tickets': [],
        'snacks': snacks,
        'user_id': SessionService.instance.userId,
      },
    );

    final data = resp.data as Map<String, dynamic>;
    final result = OrderResult.fromJson(data);

    // Limpiar carrito
    quantities.clear();
    _recalculateTotal();

    return result;
  }
}
