import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_up_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const Color _purple = Color(0xFF4B4CC1);
  static const Color _headerGrey = Color(0xFFBFBFBF);
  static const Color _fieldBg = Color(0xFFF0ECEC);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(SignUpController());
    final base = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    final localTheme = base.copyWith(
      colorScheme: base.colorScheme.copyWith(
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
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
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
            child: Container(
              constraints: BoxConstraints(minHeight: size.height - topPadding),
              color: _headerGrey,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Form(
                key: ctrl.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    Center(
                      child: Image.asset(
                        'assets/images/cinestar.png',
                        height: 110,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Center(
                      child: Text(
                        'CREAR\nNUEVA CUENTA',
                        textAlign: TextAlign.center,
                        style: base.textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF243328),
                          fontWeight: FontWeight.w600,
                          height: 1.05,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '¿Ya estás registrado?  ',
                            style: base.textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.offAllNamed('/sign-in'),
                            child: Text(
                              'Inicie sesión aquí',
                              style: base.textTheme.bodyMedium?.copyWith(
                                color: _purple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: ctrl.nombreCtrl,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.givenName],
                      decoration: const InputDecoration(
                        hintText: 'Nombre',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: ctrl.validarNombre,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: ctrl.apellidoCtrl,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.familyName],
                      decoration: const InputDecoration(
                        hintText: 'Apellido',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: ctrl.validarApellido,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: ctrl.emailCtrl,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      validator: ctrl.validarEmail,
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: ctrl.telefonoCtrl,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      decoration: const InputDecoration(
                        hintText: 'Teléfono',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: ctrl.validarTelefono,
                    ),
                    const SizedBox(height: 10),

                    Obx(
                      () => TextFormField(
                        controller: ctrl.passCtrl,
                        obscureText: !ctrl.mostrarPass.value,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
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
                    const SizedBox(height: 10),

                    Obx(
                      () => TextFormField(
                        controller: ctrl.pass2Ctrl,
                        obscureText: !ctrl.mostrarPass2.value,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          hintText: 'Confirmar contraseña',
                          prefixIcon: const Icon(Icons.lock_reset),
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

                    const SizedBox(height: 12),

                    Text(
                      'Al continuar, aceptas nuestros Términos y condiciones y\nPolítica de privacidad.',
                      textAlign: TextAlign.center,
                      style: base.textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _purple,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                            elevation: 0,
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
                              : const Text('Inscribirse'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
