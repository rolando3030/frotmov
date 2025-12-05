import 'package:flutter/material.dart';
import '../../widgets/filter_shell.dart';
import '../../theme/app_theme.dart'; // <- esta es la ruta del theme combinado

class RoomTypeFilterScreen extends StatelessWidget {
  const RoomTypeFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final types = [
      '2D',
      'REGULAR',
      '3D',
      'PRIME',
      'SCREENX',
      'XTREME',
      'VIP',
      'SIN VACUNA',
    ];

    return FilterShell(
      headerColor: AppTheme.steel,
      titleLink: 'Filtra por Sala',
      titleIcon: Icons.tv_outlined,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.6,
        ),
        itemCount: types.length,
        itemBuilder: (_, i) {
          return InkWell(
            onTap: () => Navigator.pop(context, types[i]),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.blue, width: 2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                types[i],
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
