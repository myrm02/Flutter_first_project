import 'dart:convert';                         // Permet de transformer du JSON <-> objets Dart (json.encode/json.decode)
import 'package:http/http.dart' as http;       // Package officiel pour faire des requêtes HTTP (GET, POST, etc.)
import '../models/product.dart';               // Import du modèle Product (on en a besoin pour transformer la réponse JSON en objets)

class ApiService {                             // Classe service qui centralise les appels API
  static const String baseUrl = 'https://fakestoreapi.com';
  // URL de base de ton API (constante car elle ne change pas)

  // Méthode pour récupérer tous les produits
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Impossible de charger les produits : $e');
    }
  }

  // Méthode pour récupérer un seul produit
  Future<Product> fetchSingleProduct(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
        Map<String, dynamic>.from(json.decode(response.body));
        return Product.fromJson(jsonData);
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Impossible de charger le produit : $e');
    }
  }
}