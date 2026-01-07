import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category
  });

  // Transforme un document Firestore en objet Product
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      imageUrl: data['imageUrl'] ?? 'https://cdn-icons-png.flaticon.com/512/1253/1253323.png',
      category: data['category'] ?? 'Général',
    );
  }
}