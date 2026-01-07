import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/auth_service.dart';
import '../models/product.dart';
import 'login_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String searchQuery = "";
  String userEmail = "Chargement...";

  final Color marronChocolat = const Color(0xFF8B4513);
  final Color vertOlive = const Color(0xFF556B2F);
  final Color grisFond = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    String? email = await AuthService().getUserEmail();
    setState(() => userEmail = email ?? "Utilisateur");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisFond,
      body: Column(
        children: [
          _buildStyledHeader(),
          _buildSearchBar(),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('produits').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text("Erreur de connexion"));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!.docs
                    .map((doc) => Product.fromFirestore(doc))
                    .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();

                if (products.isEmpty) return const Center(child: Text("Catalogue vide"));

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) => _buildProductCard(products[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: marronChocolat,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _showAddProductDialog,
      ),
    );
  }

  // header
  Widget _buildStyledHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [marronChocolat, vertOlive]),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("OptiLook", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(userEmail, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ]),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          )
        ],
      ),
    );
  }

  // Barre de recherche
  Widget _buildSearchBar() {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
          child: TextField(
            onChanged: (v) => setState(() => searchQuery = v),
            decoration: InputDecoration(
              hintText: "Rechercher...",
              prefixIcon: Icon(Icons.search, color: vertOlive),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

  // Carte produit (Lister + Modifier + Supprimer)
  Widget _buildProductCard(Product p) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(p.imageUrl, fit: BoxFit.cover, width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                  ),
                ),
                // Boutons d'action sur l'image
                Positioned(
                  top: 5,
                  right: 5,
                  child: Row(
                    children: [
                      _actionButton(Icons.edit, Colors.blue, () => _showEditProductDialog(p)),
                      const SizedBox(width: 5),
                      _actionButton(Icons.delete, Colors.red, () => FirebaseFirestore.instance.collection('produits').doc(p.id).delete()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                Text("${p.price} FC", style: TextStyle(color: marronChocolat, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  // dialogue ajout
  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    _showDialog("Ajouter un produit", "Enregistrer", nameCtrl, priceCtrl, (name, price) {
      FirebaseFirestore.instance.collection('produits').add({
        'name': name,
        'price': price,
        'imageUrl': "https://images.unsplash.com/photo-1572635196237-14b3f281503f?q=80&w=300&auto=format&fit=crop",
        'category': 'Solaire',
      });
    });
  }

  void _showEditProductDialog(Product p) {
    final nameCtrl = TextEditingController(text: p.name);
    final priceCtrl = TextEditingController(text: p.price);
    _showDialog("Modifier le produit", "Mettre à jour", nameCtrl, priceCtrl, (name, price) {
      FirebaseFirestore.instance.collection('produits').doc(p.id).update({'name': name, 'price': price});
    });
  }
  // Boite de dialogue
  void _showDialog(String title, String btnText, TextEditingController nCtrl, TextEditingController pCtrl, Function(String, String) onSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nCtrl, decoration: const InputDecoration(labelText: "Nom")),
          TextField(controller: pCtrl, decoration: const InputDecoration(labelText: "Prix (FC)")),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: vertOlive),
            onPressed: () {
              onSuccess(nCtrl.text, pCtrl.text);
              Navigator.pop(context);
            },
            child: Text(btnText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}