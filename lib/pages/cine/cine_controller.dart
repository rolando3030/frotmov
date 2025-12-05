import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/cinema.dart';

class CineController extends GetxController {
  var cinemas = <Cinema>[].obs;
  var isLoading = false.obs;
  var error = RxnString();

  final String baseUrl = 'http://10.0.2.2:4567';

  @override
  void onInit() {
    super.onInit();
    fetchCinemas();
  }

  Future<void> fetchCinemas() async {
    try {
      isLoading.value = true;
      error.value = null;

      final uri = Uri.parse('$baseUrl/cinemas');
      final resp = await http.get(uri);

      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as List;
        cinemas.value = data.map((e) => Cinema.fromJson(e)).toList();
      } else {
        error.value = 'Error: ${resp.statusCode}';
      }
    } catch (e) {
      error.value = 'Error de red: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
