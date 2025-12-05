import 'package:get/get.dart';

class MoreFilterController extends GetxController {
  final availableGenres = <String>[
    'Acción',
    'Comedia',
    'Drama',
    'Terror',
    'Animación',
  ];

  final selectedGenres = <String>[].obs;

  void toggleGenre(String genre) {
    if (selectedGenres.contains(genre)) {
      selectedGenres.remove(genre);
    } else {
      selectedGenres.add(genre);
    }
  }

  void clear() => selectedGenres.clear();
}
