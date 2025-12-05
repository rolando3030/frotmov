// lib/models/movie.dart

class Movie {
  final int id;
  final String title;
  final String path;
  final bool estreno;
  final String synopsis;
  final List<String> genres; // 👈 nuevo

  const Movie({
    required this.id,
    required this.title,
    required this.path,
    required this.estreno,
    required this.synopsis,
    this.genres = const [], // 👈 por defecto lista vacía
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final rawGenres = json['genres'];

    List<String> parsedGenres;
    if (rawGenres is List) {
      parsedGenres = rawGenres.map((e) => e.toString()).toList();
    } else {
      parsedGenres = const [];
    }

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      path: json['image_path'] ?? '',
      estreno: json['estreno'] == true || json['estreno'] == 1,
      synopsis: json['synopsis'] ?? '',
      genres: parsedGenres, // 👈 se guarda la lista
    );
  }
}
