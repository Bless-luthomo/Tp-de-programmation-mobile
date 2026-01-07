import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';
import 'register_page.dart';
import 'product_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.visibility,
              size: 100,
              color: Color(0xFF556B2F),
            ),
            const SizedBox(height: 15),
            const Text(
              "OptiLook",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B4513),
                letterSpacing: 1.2,
              ),
            ),
            const Text(
              "Votre regard, notre expertise",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            _buildInputField(
              label: 'Email',
              icon: Icons.email_outlined,
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Mot de passe',
              icon: Icons.lock_outline,
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 30),

            // BOUTON CONNEXION
            ElevatedButton(
              onPressed: () async {
                User? user = await _authService.loginWithEmail(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
                if (user != null) {
                  // Redirection de remplacement (on ne peut pas revenir en arrière)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Erreur : Identifiants incorrects"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF556B2F),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                "Se connecter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade400)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Ou continuer avec", style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade400)),
              ],
            ),
            const SizedBox(height: 25),

            _socialButton(
              label: "Continuer avec Google",
              icon: FontAwesomeIcons.google,
              iconColor: Colors.red,
              onTap: () async {
                User? user = await _authService.signInWithGoogle();
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductPage()),
                  );
                }
              },
            ),
            const SizedBox(height: 15),
            _socialButton(
              label: "Continuer avec X",
              icon: FontAwesomeIcons.xTwitter,
              iconColor: Colors.black,
              onTap: () {
              },
            ),
            const SizedBox(height: 35),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Pas encore de compte ? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "S'enregistrer ici",
                    style: TextStyle(
                      color: Color(0xFF8B4513),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF556B2F)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF556B2F), width: 2),
        ),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: FaIcon(icon, size: 24, color: iconColor),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.black38,
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.green),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}