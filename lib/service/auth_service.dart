import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Vérifier si l'utilisateur est déjà connecté
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Sauvegarde locale (Shared Preferences)
  Future<void> _saveUserSession(String? email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (email != null) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
    }
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  // Connexion email
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveUserSession(result.user?.email);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  //Inscription email
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _saveUserSession(result.user?.email);
      return result.user;
    } catch (e) {
      print("Erreur inscription: $e");
      return null;
    }
  }

  // Connexion google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      await _saveUserSession(result.user?.email);
      return result.user;
    } catch (e) {
      print("Erreur Google Sign-In: $e");
      return null;
    }
  }

  //  Deconnexion
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}