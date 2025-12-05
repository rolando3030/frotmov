// lib/pages/cine/cine_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/cinema.dart';
import 'cine_controller.dart';

class CinePage extends StatelessWidget {
  const CinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CineController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.value != null) {
        return Center(child: Text(controller.error.value!));
      }

      final cinemas = controller.cinemas;
      if (cinemas.isEmpty) {
        return const Center(child: Text('No hay cines disponibles'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: cinemas.length,
        itemBuilder: (_, i) {
          final c = cinemas[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.theaters_outlined),
              title: Text(c.name),
              subtitle: Text(c.address),
            ),
          );
        },
      );
    });
  }
}
