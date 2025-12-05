import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _purple = Color(0xFF5B4DB7);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _purple, // 👈 barra morada
        selectedItemColor: Colors.white, // ícono+texto activos en blanco
        unselectedItemColor: Colors.white70, // inactivos más claros
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            label: 'Película',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.theaters_outlined),
            label: 'Cine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_mall_outlined),
            label: 'Dulcería',
          ),
        ],
      ),
    );
  }
}
