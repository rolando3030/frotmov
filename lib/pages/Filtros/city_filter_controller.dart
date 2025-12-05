// lib/pages/Filtros/city_filter_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CityFilterController extends GetxController {
  final cities = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  final String baseUrl = 'http://10.0.2.2:4567'; // backend Ruby

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  Future<void> fetchCities() async {
    try {
      isLoading.value = true;
      error.value = null;

      final uri = Uri.parse('$baseUrl/cities');
      final resp = await http.get(uri);

      if (resp.statusCode == 200) {
        final List data = json.decode(resp.body);
        cities.assignAll(data.cast<Map<String, dynamic>>());
      } else {
        error.value = 'Error HTTP: ${resp.statusCode}';
      }
    } catch (e) {
      error.value = 'Error al cargar ciudades';
    } finally {
      isLoading.value = false;
    }
  }
}
