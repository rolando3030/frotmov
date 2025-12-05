import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_repository.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final cargando = false.obs;
  final mostrarPass = false.obs;
  final errorMsg = RxnString();

  late final AuthRepository _repo;

  @override
  void onInit() {
    _repo = Get.find<AuthRepository>();
    super.onInit();
  }

  void toggleMostrarPass() => mostrarPass.value = !mostrarPass.value;

  String? validarEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim());
    return ok ? null : 'Correo inválido';
  }

  String? validarPass(String? v) {
    if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  Future<void> submit() async {
    errorMsg.value = null;
    if (!(formKey.currentState?.validate() ?? false)) return;

    cargando.value = true;
    try {
      await _repo.signIn(
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
      );

      // Si todo OK → a Home
      Get.offAllNamed('/home');
    } on AuthError catch (e) {
      final msg = e.message;
      errorMsg.value = msg;
      Get.snackbar(
        'Error',
        msg,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      errorMsg.value = 'Error inesperado. Intenta de nuevo.';
      Get.snackbar(
        'Error',
        errorMsg.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!isClosed) {
        cargando.value = false;
      }
    }
  }
}
