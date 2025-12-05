// lib/pages/home/home_controller.dart
import 'package:get/get.dart';

class HomeController extends GetxController {
  /// índice del BottomNavigationBar
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
