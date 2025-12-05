import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CinemaFilterController extends GetxController {
  static const _baseUrl = 'http://10.0.2.2:4567';

  final cinemas = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  int? cityId;

  CinemaFilterController({this.cityId});

  @override
  void onInit() {
    super.onInit();
    fetchCinemas();
  }

  Future<void> fetchCinemas() async {
    try {
      isLoading.value = true;
      error.value = null;

      Uri uri;
      if (cityId != null) {
        uri = Uri.parse('$_baseUrl/cinemas/by_city/$cityId');
      } else {
        uri = Uri.parse('$_baseUrl/cinemas');
      }

      final resp = await http.get(uri);

      if (resp.statusCode != 200) {
        error.value = 'Error HTTP: ${resp.statusCode}';
        return;
      }

      final data = jsonDecode(resp.body) as List;
      cinemas.assignAll(data.cast<Map<String, dynamic>>());
    } catch (e) {
      error.value = 'Error cargando cines';
    } finally {
      isLoading.value = false;
    }
  }
}
