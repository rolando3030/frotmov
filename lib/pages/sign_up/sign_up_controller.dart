import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_repository.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final pass2Ctrl = TextEditingController();

  final cargando = false.obs;
  final mostrarPass = false.obs;
  final mostrarPass2 = false.obs;

  late final AuthRepository _repo;

  @override
  void onInit() {
    _repo = Get.find<AuthRepository>();
    super.onInit();
  }

  void togglePass() => mostrarPass.value = !mostrarPass.value;
  void togglePass2() => mostrarPass2.value = !mostrarPass2.value;

  String? _noVacio(String? v, String label) {
    if (v == null || v.trim().isEmpty) return 'Ingresa $label';
    return null;
  }

  String? validarNombre(String? v) => _noVacio(v, 'tu nombre');
  String? validarApellido(String? v) => _noVacio(v, 'tu apellido');
  String? validarTelefono(String? v) => _noVacio(v, 'tu teléfono');

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

  String? validarPass2(String? v) {
    if (v == null || v.isEmpty) return 'Repite tu contraseña';
    if (v != passCtrl.text) return 'Las contraseñas no coinciden';
    return null;
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    cargando.value = true;
    try {
      final auth = await _repo.signUp(
        nombre: nombreCtrl.text.trim(),
        apellido: apellidoCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        telefono: telefonoCtrl.text.trim(),
        password: passCtrl.text,
      );

      // Si el backend devolvió token → ya hay sesión, a Home
      if (auth.tokens.access.isNotEmpty) {
        Get.offAllNamed('/home');
      } else {
        // Si no hay token, lo mandamos a Sign In
        Get.offAllNamed('/sign-in');
      }
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
