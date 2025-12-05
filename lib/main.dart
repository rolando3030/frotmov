// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ===== Services
import 'services/auth_repository.dart';
import 'services/session_service.dart';

// ===== Pages
import 'pages/home/home_page.dart';
import 'pages/sign_in/sign_in_page.dart';
import 'pages/sign_up/sign_up_page.dart';
import 'pages/reset_password/reset_password_page.dart';
import 'pages/confirmar_password/confirmar_password_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inyectar servicios globales de autenticación / sesión
  final authRepo = await AuthRepository.create();
  Get.put<AuthRepository>(authRepo, permanent: true);
  Get.put<SessionService>(SessionService(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cine Star App',
      initialRoute: '/sign-in',
      getPages: [
        GetPage(name: '/sign-in', page: () => const SignInPage()),
        GetPage(name: '/sign-up', page: () => const SignUpPage()),
        GetPage(name: '/reset-password', page: () => ResetPasswordPage()),
        GetPage(
          name: '/confirmar-password',
          page: () => const ConfirmarPasswordPage(),
        ),
        // 👇 Ahora el /home es la pantalla completa con tabs, slider, etc.
        GetPage(name: '/home', page: () => const HomePage()),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4B4CC1)),
        useMaterial3: true,
      ),
    );
  }
}
