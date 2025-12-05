import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_repository.dart';

class AppTopBar extends StatelessWidget {
  final bool hasNotifications;
  const AppTopBar({super.key, this.hasNotifications = true});

  static const _purple = Color(0xFF5B4DB7);

  @override
  Widget build(BuildContext context) {
    // Repositorio de auth para poder hacer logout
    final auth = Get.find<AuthRepository>();

    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(color: _purple),
      child: Row(
        children: [
          // Logo
          Image.asset(
            'assets/images/cinestar.png',
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.movie_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),

          const Spacer(),

          // Icono de usuario (solo decorativo)
          const _RoundIcon(icon: Icons.person),

          const SizedBox(width: 10),

          // Campanita de notificaciones
          _BellIcon(hasNotifications: hasNotifications),

          const SizedBox(width: 10),

          // 👇 Aquí va el botón de CERRAR SESIÓN
          _RoundIcon(
            icon: Icons.logout,
            onTap: () async {
              await auth.signOut();
              Get.offAllNamed('/sign-in');
            },
          ),

          const SizedBox(width: 10),

          // Lupa de búsqueda (solo decorativo por ahora)
          const _RoundIcon(icon: Icons.search),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _RoundIcon({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final circle = CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white.withOpacity(.2),
      child: Icon(icon, size: 16, color: Colors.white),
    );

    // Si no hay onTap, solo mostramos el círculo
    if (onTap == null) return circle;

    // Si hay onTap, lo envolvemos en un InkWell para que sea clickeable
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: circle,
    );
  }
}

class _BellIcon extends StatelessWidget {
  final bool hasNotifications;
  const _BellIcon({required this.hasNotifications});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const _RoundIcon(icon: Icons.notifications_outlined),
        if (hasNotifications)
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB300),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
      ],
    );
  }
}
