import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reset_password_controller.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

  final ResetPasswordController ctrl = Get.put(ResetPasswordController());

  static const Color _purple = Color(0xFF4B4CC1);
  static const Color _headerGrey = Color(0xFFBFBFBF);
  static const Color _fieldBg = Color(0xFFF0ECEC);

  @override
  Widget build(BuildContext context) {
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
        labelStyle: const TextStyle(color: Colors.black54),
        floatingLabelStyle: const TextStyle(color: Colors.black54),
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
              child: Container(
                color: _headerGrey,
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
                        'Escriba su correo\nelectrónico',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF232323),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ayúdanos a encontrar tu\nCuenta',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Image.asset(
                          'assets/images/grupo_interactuando.png',
                          height: 180,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextFormField(
                        controller: ctrl.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'E-mail',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                        validator: ctrl.validarEmail,
                      ),

                      const SizedBox(height: 16),

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
                                : const Text('BUSCAR'),
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
