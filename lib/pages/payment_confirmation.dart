import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class PaymentConfirmation extends StatelessWidget {
  const PaymentConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enregistrement de commande')),
      drawer: const AppDrawer(),
      body: const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check),
          SizedBox(width: 8),
          Text('Votre commande a été enregistrée avec succès!'),
        ],
      )),
    );
  }
}