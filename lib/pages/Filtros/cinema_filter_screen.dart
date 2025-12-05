import 'package:flutter/material.dart';
import '../../widgets/filter_shell.dart';
import '../../theme/app_theme.dart'; // <- esta es la ruta del theme combinado

class CinemaFilterScreen extends StatelessWidget {
  const CinemaFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cinemas = [
      'CP SAN MIGUEL',
      'CP VILLA MARIA DEL TRIUNFO',
      'CP AREQUIPA MALL PLAZA',
      'CP NORTE',
      'CP MALL DEL SUR',
      'CP PIURA',
      'CP PURUCHUCO',
      'CP HUANCAYO REAL PLAZA',
      'CP PRIMAVERA',
    ];

    return FilterShell(
      headerColor: AppTheme.navy,
      titleLink: 'Filtrar por cine',
      titleIcon: Icons.theaters_outlined,
      child: ListView.separated(
        itemCount: cinemas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              color: AppTheme.navy,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white70, width: 1),
            ),
            child: ListTile(
              title: Text(
                cinemas[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () => Navigator.pop(context, cinemas[i]),
            ),
          );
        },
      ),
    );
  }
}
