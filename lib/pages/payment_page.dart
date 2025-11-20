import 'package:flutter/material.dart';
// 🔥 AJOUT : Import Firebase Auth pour la connexion
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/drawer.dart';
import 'payment_confirmation.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // 🔥 AJOUT : Controllers pour gérer les champs de texte
  final _nameController = TextEditingController();
  final _card_numberController = TextEditingController();
  final _codeController = TextEditingController();

  // 🔥 AJOUT : Variables pour gérer l'état de la page
  bool _isLoading = false; // Indique si une connexion est en cours
  String _errorMessage = ''; // Stocke les messages d'erreur

  @override
  void dispose() {
    // 🔥 AJOUT : Nettoie les controllers pour éviter les fuites mémoire
    _nameController.dispose();
    _card_numberController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  // 🔥 AJOUT : Fonction principale de connexion
  Future<void> _paymentSubmit() async {
    // Validation basique des champs
    if (_nameController.text.trim().isEmpty || _card_numberController.text.isEmpty || _codeController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs';
      });
      return;
    }

    // Active l'état de chargement
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {

      // Si la connexion réussit et que le widget est toujours monté
      if (mounted) {
        // Redirige vers la page de confirmation de paiement
        Navigator.push(
            context,
            MaterialPageRoute<void>(
            builder: (context) => const PaymentConfirmation(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // 🔥 AJOUT : Gestion des erreurs spécifiques Firebase
      setState(() {
        _errorMessage = _getErrorMessage(e.code);
      });
    } catch (e) {
      // Gestion des autres erreurs
      setState(() {
        _errorMessage = 'Une erreur inattendue s\'est produite';
      });
    }

    // Désactive l'état de chargement
    setState(() {
      _isLoading = false;
    });
  }

  // 🔥 AJOUT : Fonction qui traduit les codes d'erreur Firebase en français
  // Liste des erreurs ici : https://firebase.google.com/docs/auth/admin/errors?hl=fr
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cette adresse email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      default:
        return 'Une erreur est survenue. Veuillez réessayer.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      // 🔥 AJOUT : Le drawer est accessible même depuis la page de connexion
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône de connexion
            Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.blue[600],
            ),
            const SizedBox(height: 30),

            // 🔥 AJOUT : Champ email avec validation
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du titualaire',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              keyboardType: TextInputType.text,
              enabled: !_isLoading, // Désactivé pendant le chargement
            ),
            const SizedBox(height: 16),

            // 🔥 AJOUT : Champ email avec validation
            TextField(
              controller: _card_numberController,
              decoration: const InputDecoration(
                labelText: 'Numéro de carte',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.card_giftcard),
              ),
              keyboardType: TextInputType.number,
              enabled: !_isLoading, // Désactivé pendant le chargement
            ),
            const SizedBox(height: 16),

            // 🔥 AJOUT : Champ mot de passe
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.code),
              ),
              keyboardType: TextInputType.text,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),

            // 🔥 AJOUT : Affichage conditionnel des messages d'erreur
            if (_errorMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
              ),

            if (_errorMessage.isNotEmpty) const SizedBox(height: 16),

            // 🔥 AJOUT : Bouton de connexion avec état de chargement
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _paymentSubmit, // Désactivé pendant chargement
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirmer', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
