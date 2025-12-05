import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'confirmar_password_controller.dart';

class ConfirmarPasswordPage extends StatelessWidget {
  const ConfirmarPasswordPage({super.key});

  static const Color _purple = Color(0xFF4B4CC1);
  static const Color _headerGrey = Color(0xFFBFBFBF);
  static const Color _fieldBg = Color(0xFFF0ECEC);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ConfirmarPasswordController());
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    final localTheme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: _purple,
        onPrimary: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: _purple,
        selectionColor: Color(0x334B4CC1),
        selectionHandleColor: _purple,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _fieldBg,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.black45),
      ),
    );

    return Theme(
      data: localTheme,
      child: Scaffold(
        backgroundColor: _headerGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Form(
                  key: ctrl.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // back
                      InkWell(
                        onTap: () => Get.back(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: _purple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      Text(
                        '¡FELICIDADES!\nRestablece tu contraseña',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF232323),
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Debe tener al menos 6 caracteres',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Image.asset(
                          'assets/images/personas_hablando.png',
                          height: 180,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // código
                      TextFormField(
                        controller: ctrl.codigoCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Código recibido',
                        ),
                        validator: ctrl.validarCodigo,
                      ),
                      const SizedBox(height: 12),

                      // nueva contraseña
                      Obx(
                        () => TextFormField(
                          controller: ctrl.passCtrl,
                          obscureText: !ctrl.mostrarPass.value,
                          decoration: InputDecoration(
                            hintText: 'Nueva contraseña',
                            suffixIcon: IconButton(
                              onPressed: ctrl.togglePass,
                              icon: Icon(
                                ctrl.mostrarPass.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: ctrl.validarPass,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // confirmar contraseña
                      Obx(
                        () => TextFormField(
                          controller: ctrl.pass2Ctrl,
                          obscureText: !ctrl.mostrarPass2.value,
                          decoration: InputDecoration(
                            hintText: 'Confirmar contraseña',
                            suffixIcon: IconButton(
                              onPressed: ctrl.togglePass2,
                              icon: Icon(
                                ctrl.mostrarPass2.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: ctrl.validarPass2,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _purple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                            onPressed: ctrl.cargando.value ? null : ctrl.submit,
                            child: ctrl.cargando.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('RESTABLECER CONTRASEÑA'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
