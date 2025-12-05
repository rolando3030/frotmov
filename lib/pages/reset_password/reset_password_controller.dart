import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_repository.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final cargando = false.obs;

  late final AuthRepository _repo;

  @override
  void onInit() {
    _repo = Get.find<AuthRepository>();
    super.onInit();
  }

  String? validarEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim());
    return ok ? null : 'Correo inválido';
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    cargando.value = true;
    try {
      final email = emailCtrl.text.trim();

      // El repo devuelve el token en modo dev (si el backend lo manda)
      final token = await _repo.resetPasswordRequest(email: email);

      Get.snackbar(
        'Listo',
        'Te enviamos un código (dev) para restablecer tu contraseña',
        snackPosition: SnackPosition.BOTTOM,
      );

      final args = <String, dynamic>{'email': email};
      if (token != null && token.isNotEmpty) {
        args['devToken'] = token;
      }

      Get.toNamed('/confirmar-password', arguments: args);
    } on AuthError catch (e) {
      final msg = e.message;
      Get.snackbar(
        'Error',
        msg,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      Get.snackbar(
        'Error',
        'Error inesperado. Intenta de nuevo.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!isClosed) {
        cargando.value = false;
      }
    }
  }
}
