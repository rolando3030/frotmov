import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_repository.dart';

class ConfirmarPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final codigoCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final pass2Ctrl = TextEditingController();

  final cargando = false.obs;
  final mostrarPass = false.obs;
  final mostrarPass2 = false.obs;

  late final AuthRepository _repo;
  late final String email;

  @override
  void onInit() {
    _repo = Get.find<AuthRepository>();

    final args = Get.arguments as Map<String, dynamic>?;

    email = (args?['email'] as String?) ?? '';

    // En modo dev, si vino el token desde reset, lo rellenamos
    final devToken = args?['devToken'] as String?;
    if (devToken != null && devToken.isNotEmpty) {
      codigoCtrl.text = devToken;
    }

    super.onInit();
  }

  void togglePass() => mostrarPass.value = !mostrarPass.value;
  void togglePass2() => mostrarPass2.value = !mostrarPass2.value;

  String? validarCodigo(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa el código';
    if (v.trim().length < 4) return 'Código inválido';
    return null;
  }

  String? validarPass(String? v) {
    if (v == null || v.isEmpty) return 'Ingresa la nueva contraseña';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? validarPass2(String? v) {
    if (v == null || v.isEmpty) return 'Repite la contraseña';
    if (v != passCtrl.text) return 'No coincide';
    return null;
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    cargando.value = true;
    try {
      await _repo.resetPasswordConfirm(
        email: email,
        token: codigoCtrl.text.trim(),
        newPassword: passCtrl.text,
      );

      if (!isClosed) {
        Get.snackbar(
          'OK',
          'Contraseña actualizada',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/sign-in');
      }
    } on AuthError catch (e) {
      final msg = e.message;
      if (!isClosed) {
        Get.snackbar(
          'Error',
          msg,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      if (!isClosed) {
        Get.snackbar(
          'Error',
          'Error inesperado. Intenta de nuevo.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (!isClosed) {
        cargando.value = false;
      }
    }
  }
}
