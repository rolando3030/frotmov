import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_in_controller.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static const _purple = Color(0xFF4B4CC1);
  static const _headerGrey = Color(0xFFBFBFBF);
  static const _fieldBg = Color(0xFFF0ECEC);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(SignInController());

    final base = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final topPad = MediaQuery.paddingOf(context).top;

    final logoH = (size.height * 0.15).clamp(120.0, 160.0);
    final titleSize = (size.width * 0.14).clamp(44.0, 56.0);
    final gapLogoTitle = (size.height * 0.035).clamp(24.0, 36.0);
    final gapTitleBottom = (size.height * 0.10).clamp(84.0, 120.0);

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
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.black45),
        labelStyle: const TextStyle(color: Colors.black54),
        floatingLabelStyle: const TextStyle(color: Colors.black54),
      ),
    );

    final remember = false.obs;

    return Theme(
      data: localTheme,
      child: Scaffold(
        backgroundColor: _headerGrey,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(flex: 6, child: Container(color: _headerGrey)),
                  Expanded(flex: 4, child: Container(color: _purple)),
                ],
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height - topPad),
                  child: Column(
                    children: [
                      const SizedBox(height: 22),
                      Center(
                        child: Image.asset(
                          'assets/images/cinestar.png',
                          height: logoH,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                      SizedBox(height: gapLogoTitle),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(
                            'PELÍCULAS PARA\nTODA LA FAMILIA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'TanAegean',
                              fontSize: titleSize,
                              color: Colors.white,
                              height: 1.05,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: gapTitleBottom),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: const Offset(0, -28),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 22,
                            offset: Offset(0, 10),
                            color: Color(0x22000000),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                        child: Form(
                          key: ctrl.formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: ctrl.emailCtrl,
                                autofillHints: const [
                                  AutofillHints.username,
                                  AutofillHints.email,
                                ],
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'E-mail',
                                  prefixIcon: Icon(Icons.mail_outline),
                                ),
                                validator: ctrl.validarEmail,
                              ),
                              const SizedBox(height: 12),
                              Obx(
                                () => TextFormField(
                                  controller: ctrl.passCtrl,
                                  obscureText: !ctrl.mostrarPass.value,
                                  autofillHints: const [AutofillHints.password],
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => ctrl.submit(),
                                  decoration: InputDecoration(
                                    hintText: 'Contraseña',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: ctrl.toggleMostrarPass,
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
                              Row(
                                children: [
                                  Obx(
                                    () => GestureDetector(
                                      onTap: () =>
                                          remember.value = !remember.value,
                                      child: Row(
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 150,
                                            ),
                                            width: 18,
                                            height: 18,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: remember.value
                                                    ? _purple
                                                    : Colors.black26,
                                                width: 1.4,
                                              ),
                                              color: remember.value
                                                  ? const Color(0x114B4CC1)
                                                  : Colors.transparent,
                                            ),
                                            child: remember.value
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: _purple,
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Recuérdame',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => Get.toNamed('/reset-password'),
                                    child: const Text(
                                      '¿Olvidaste tu contraseña?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _purple,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _purple,
                                      foregroundColor: Colors.white,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: .4,
                                      ),
                                    ),
                                    onPressed: ctrl.cargando.value
                                        ? null
                                        : ctrl.submit,
                                    child: ctrl.cargando.value
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text('INGRESAR'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '¿No tienes cuenta?  ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.toNamed('/sign-up'),
                                    child: const Text(
                                      'Crear Cuenta',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _purple,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => ctrl.errorMsg.value == null
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          ctrl.errorMsg.value!,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                          ),
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
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 28,
                child: ColoredBox(color: _purple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
