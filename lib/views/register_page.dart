import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';
import 'product_page.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF556B2F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const Icon(Icons.person_add_outlined, size: 80, color: Color(0xFF556B2F)),
            const SizedBox(height: 10),
            const Text(
              "Créer un compte",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513)
              ),
            ),
            const Text(
              "Rejoignez la communauté OptiLook",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            _buildInputField(
                label: "Nom complet",
                icon: Icons.person_outline,
                controller: _nameController
            ),
            const SizedBox(height: 20),

            _buildInputField(
                label: "Email",
                icon: Icons.email_outlined,
                controller: _emailController
            ),
            const SizedBox(height: 20),

            _buildInputField(
                label: "Mot de passe",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController
            ),

            const SizedBox(height: 40),

            // BOUTON S'ENREGISTRER
            ElevatedButton(
              onPressed: () async {
                if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                  User? user = await _authService.registerWithEmail(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Compte créé avec succès !")),
                    );

                    // Redirection directe vers le Menu
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const ProductPage()),
                          (route) => false, // Supprime tout l'historique de navigation
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erreur lors de l'inscription."),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: const Text(
                  "S'inscrire maintenant",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Déjà un compte ? Connectez-vous",
                style: TextStyle(color: Color(0xFF556B2F), fontWeight: FontWeight.w600),
              ),
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
    required TextEditingController controller
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
}