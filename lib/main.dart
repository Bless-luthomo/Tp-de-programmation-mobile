import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'service/auth_service.dart';
import 'views/login_page.dart';
import 'firebase_options.dart';
import'views/product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Vérification de la session avant de lancer l'app
  AuthService authService = AuthService();
  bool loggedIn = await authService.isLoggedIn();

  runApp(OptiLookApp(isLoggedIn: loggedIn));
}

class OptiLookApp extends StatelessWidget {
  final bool isLoggedIn;
  const OptiLookApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiLook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
      ),
      // Si connecté -> Menu, sinon -> Login
      home: isLoggedIn ? const ProductPage() : const LoginPage(),
    );
  }
}

class PlaceholderMenu extends StatelessWidget {
  const PlaceholderMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OptiLook Menu")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AuthService().signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: const Text("Déconnexion"),
        ),
      ),
    );
  }
}