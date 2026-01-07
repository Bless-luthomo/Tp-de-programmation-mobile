import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Récupérer la liste des produits
  Stream<List<Product>> getProducts() {
    return _db.collection('produits').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  // Ajouter un produit (pour la fonctionnalité "Ajouter" du menu)
  Future<void> addProduct(String name, String price, String imageUrl) {
    return _db.collection('produits').add({
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': 'Nouveauté',
    });
  }
}