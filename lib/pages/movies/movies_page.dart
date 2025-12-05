import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/movie.dart';
import '../movie_detail/movie_detail_page.dart';

// pantallas de filtros
import '../Filtros/city_filter_screen.dart';
import '../Filtros/date_filter_screen.dart';
import '../Filtros/more_filter_screen.dart';

const String baseUrl = 'http://10.0.2.2:4567'; // backend Ruby

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  // lista ORIGINAL desde backend (última respuesta del servidor)
  List<Movie> _allMovies = [];

  // listas que se muestran (filtradas por "estreno")
  List<Movie> cartelera = [];
  List<Movie> proximos = [];

  // loading / error
  bool _isLoading = false;
  String? _error;

  // estado de filtros (texto que se ve en la barra)
  String? _cityLabel;
  String? _dateLabel;
  Map<String, dynamic>? _moreResult;

  // estado de filtros REALES que enviamos al backend
  int? _selectedCityId;
  String? _selectedDateIso; // 'YYYY-MM-DD'
  List<int> _selectedGenreIds = [];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _fetchMovies(); // al inicio: sin filtros -> /movies
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // =========================
  // 1) Llamar al backend con o sin filtros
  // =========================
  Future<void> _fetchMovies() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final hasCity = _selectedCityId != null;
      final hasDate = _selectedDateIso != null && _selectedDateIso!.isNotEmpty;
      final hasGenres = _selectedGenreIds.isNotEmpty;

      Uri uri;

      if (!hasCity && !hasDate && !hasGenres) {
        // sin filtros -> todas las pelis
        uri = Uri.parse('$baseUrl/movies');
      } else {
        // con filtros -> /movies/search
        final params = <String, String>{};
        if (hasCity) params['city_id'] = _selectedCityId.toString();
        if (hasDate) params['date'] = _selectedDateIso!;
        if (hasGenres) {
          params['genre_ids'] = _selectedGenreIds.join(',');
        }

        uri = Uri.parse(
          '$baseUrl/movies/search',
        ).replace(queryParameters: params);
      }

      final resp = await http.get(uri);
      debugPrint('GET ${uri.toString()} -> ${resp.statusCode}');

      if (resp.statusCode == 200) {
        final List<dynamic> data = json.decode(resp.body);
        final movies = data
            .map((e) => Movie.fromJson(e as Map<String, dynamic>))
            .toList();

        setState(() {
          _allMovies = movies;
          cartelera = movies;
          proximos = movies.where((m) => m.estreno).toList();
        });
      } else {
        setState(() {
          _error = 'Error backend: ${resp.statusCode}';
        });
      }
    } catch (e) {
      debugPrint('Error al conectar con backend: $e');
      setState(() {
        _error = 'No se pudo conectar al servidor';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // =========================
  // 2) Abrir filtros
  // =========================

  // Ciudad -> devuelve { id, name }
  Future<void> _openCityFilter() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const CityFilterScreen()),
    );
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _selectedCityId = result['id'] as int?;
        _cityLabel = result['name'] as String?;
      });
      _fetchMovies(); // recargar desde backend con city_id
    }
  }

  // Fecha -> devuelve { iso, label }
  Future<void> _openDateFilter() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const DateFilterScreen()),
    );
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _selectedDateIso = result['iso'] as String?;
        _dateLabel = result['label'] as String?;
      });
      _fetchMovies(); // recargar con date
    }
  }

  // Más filtros -> devuelve { genres, languages, formats, ratings, genre_ids }
  Future<void> _openMoreFilter() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const MoreFilterScreen()),
    );
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _moreResult = result;

        final dynamic rawIds = result['genre_ids'];
        if (rawIds is List) {
          _selectedGenreIds = rawIds
              .map((e) => int.tryParse(e.toString()) ?? 0)
              .where((id) => id > 0)
              .toList();
        } else {
          _selectedGenreIds = [];
        }
      });
      _fetchMovies(); // recargar con genre_ids
    }
  }

  // =========================
  // 3) UI
  // =========================
  @override
  Widget build(BuildContext context) {
    final divider = Container(height: 1, color: Colors.black12);

    return Column(
      children: [
        // ----- Tabs -----
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 8),
          child: TabBar(
            controller: _tab,
            labelColor: Colors.red.shade700,
            unselectedLabelColor: Colors.black87,
            indicatorColor: Colors.red.shade700,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'En cartelera'),
              Tab(text: 'Próximos estrenos'),
            ],
          ),
        ),
        divider,

        // ----- Barra de filtros -----
        _FiltersBar(
          cityLabel: _cityLabel,
          dateLabel: _dateLabel,
          onCityTap: _openCityFilter,
          onDateTap: _openDateFilter,
          onMoreTap: _openMoreFilter,
        ),
        divider,

        // ----- Contenido -----
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : TabBarView(
                  controller: _tab,
                  children: [
                    _MoviesGrid(movies: cartelera),
                    _MoviesGrid(movies: proximos, forceLabel: 'PREVENTA'),
                  ],
                ),
        ),
      ],
    );
  }
}

// =====================================================
//  Widgets auxiliares
// =====================================================

class _FiltersBar extends StatelessWidget {
  final VoidCallback onCityTap;
  final VoidCallback onDateTap;
  final VoidCallback onMoreTap;
  final String? cityLabel;
  final String? dateLabel;

  const _FiltersBar({
    required this.onCityTap,
    required this.onDateTap,
    required this.onMoreTap,
    this.cityLabel,
    this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    Widget cell({
      required IconData icon,
      required String defaultText,
      String? valueText,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 22, color: Colors.black87),
                const SizedBox(height: 6),
                Text(
                  valueText ?? defaultText,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        cell(
          icon: Icons.location_on_outlined,
          defaultText: 'Ciudad',
          valueText: cityLabel,
          onTap: onCityTap,
        ),
        Container(width: 1, height: 40, color: Colors.black12),
        cell(
          icon: Icons.event_note_outlined,
          defaultText: 'Fecha',
          valueText: dateLabel,
          onTap: onDateTap,
        ),
        Container(width: 1, height: 40, color: Colors.black12),
        cell(icon: Icons.tune, defaultText: 'Opciones', onTap: onMoreTap),
      ],
    );
  }
}

class _MoviesGrid extends StatelessWidget {
  final List<Movie> movies;
  final String? forceLabel;

  const _MoviesGrid({required this.movies, this.forceLabel});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(child: Text('No hay películas'));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: GridView.builder(
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, i) {
          final m = movies[i];
          final label = forceLabel ?? (m.estreno ? 'ESTRENO' : null);

          return _PosterCard(
            movie: m,
            label: label,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(
                    title: m.title,
                    imagePath: m.path,
                    isEstreno: m.estreno,
                    synopsis: m.synopsis,
                    idiomas: const ['DOBLADA'],
                    formatos: const ['2D', 'REGULAR'],
                    genres: m.genres,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PosterCard extends StatelessWidget {
  final Movie movie;
  final String? label;
  final VoidCallback? onTap;

  const _PosterCard({required this.movie, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final genresText = movie.genres.isEmpty ? '' : movie.genres.join(' · ');

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              movie.path,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          if (label != null)
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.red.shade700,
                child: Text(
                  label!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ),
          if (genresText.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                child: Text(
                  genresText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
