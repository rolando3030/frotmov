import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/movie.dart';

class MoviesController extends GetxController {
  final String baseUrl = 'http://10.0.2.2:4567';

  final allMovies = <Movie>[].obs;      // todas las pelis
  final filteredMovies = <Movie>[].obs; // pelis después de filtros

  final isLoading = false.obs;
  final selectedGenres = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      isLoading.value = true;
      final uri = Uri.parse('$baseUrl/movies');
      final resp = await http.get(uri);

      if (resp.statusCode == 200) {
        final List data = json.decode(resp.body);
        final list = data
            .map((e) => Movie.fromJson(e as Map<String, dynamic>))
            .toList();

        allMovies.assignAll(list);
        filteredMovies.assignAll(list); // sin filtros al inicio
      } else {
        print('Error backend /movies: ${resp.statusCode}');
      }
    } catch (e) {
      print('Error al conectar con backend: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 🔄 limpiar filtros de géneros
  void clearGenreFilters() {
    selectedGenres.clear();
    filteredMovies.assignAll(allMovies);
  }

  // ✅ aplicar filtros de géneros
  void applyGenreFilters(List<String> genres) {
    selectedGenres.assignAll(genres);
    if (genres.isEmpty) {
      filteredMovies.assignAll(allMovies);
      return;
    }

    filteredMovies.assignAll(
      allMovies.where(
        (m) => m.genres.any((g) => genres.contains(g)),
      ),
    );
  }
}
