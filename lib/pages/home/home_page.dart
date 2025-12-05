import 'package:flutter/material.dart';

// widgets
import '../../widgets/app_topbar.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/hero_slider.dart';

// pages
import '../movies/movies_page.dart';
import '../cine/cine_page.dart';
import '../dulceria/dulceria_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  // Tabs/Páginas del bottom-nav
  late final List<Widget> _tabs = const [
    _HomeTab(), // Inicio (HeroSlider)
    MoviesPage(), // Películas
    CinePage(), // 👉 pestaña Cine real
    DulceriaPage(), // 👉 pestaña Dulcería real
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Expanded(
            child: IndexedStack(index: index, children: _tabs),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return const HeroSlider();
  }
}
