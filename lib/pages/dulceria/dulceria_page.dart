// lib/pages/dulceria/dulceria_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/dulceria.dart';
import 'dulceria_controller.dart';

class DulceriaPage extends StatelessWidget {
  const DulceriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DulceriaController());

    const purple = Color(0xFF6C4CCF);
    const red = Color(0xFFC8102E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(child: Text(controller.error.value!));
        }

        final items = controller.items;
        if (items.isEmpty) {
          return const Center(child: Text('No hay productos de dulcería'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final DulceriaItem item = items[i];

            // 👇 Cada item escucha los cambios en quantities
            return Obx(() {
              final qty = controller.getQty(item.id);

              return Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icono / imagen
                      if (item.imagePath.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.imagePath,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        const Icon(Icons.local_mall_outlined),

                      const SizedBox(width: 12),

                      // Nombre + categoría + precio
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Nombre del producto
                                Expanded(
                                  child: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // Precio al lado del nombre
                                Text(
                                  'S/ ${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: purple,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.category,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Controles de cantidad
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              size: 20,
                            ),
                            splashRadius: 18,
                            onPressed: () => controller.decrease(item),
                          ),
                          Text(
                            '$qty',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 20,
                            ),
                            splashRadius: 18,
                            onPressed: () => controller.increase(item),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        final total = controller.total.value;
        final hasItems = total > 0;

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: red,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: !hasItems
                    ? null
                    : () async {
                        try {
                          final result = await controller.crearOrdenDulceria();
                          if (!context.mounted) return;

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Orden creada'),
                              content: Text(
                                'ID: ${result.orderId}\n'
                                'Total: S/ ${result.totalAmount.toStringAsFixed(2)}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al comprar: $e'),
                            ),
                          );
                        }
                      },
                child: Text(
                  hasItems
                      ? 'Comprar S/ ${total.toStringAsFixed(2)}'
                      : 'Selecciona productos',
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
