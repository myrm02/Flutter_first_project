import 'package:draw_auth/pages/payment_page.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.item});

  final CartItem item;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(viewModel);
        },
      ),
    );
  }

  Widget _buildBody(CartViewModel viewModel) {
    if (viewModel.isLoading) {
      return _buildLoadingState();
    }

    if (viewModel.hasError) {
      return _buildErrorState(viewModel);
    }

    return _buildSuccessState(viewModel);
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Chargement du panier...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(CartViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => viewModel.getCartItemByProductId(widget.item.product.id),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(CartViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.items.length,
      itemBuilder: (context, index) {
        final item = viewModel.getCartItemByProductId(widget.item.product.id)!;
        return _buildCheckoutDetail(item, viewModel);
      },
    );
  }

  Widget _buildCheckoutDetail(CartItem item, CartViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Récapitulatif de votre commande', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Produit: ${item.product.title}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Quantité: ${item.quantity}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text('Prix unitaire: \$${item.product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text('Total: \$${(item.product.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const PaymentPage(),
                  ),
                ), child: const Text('Payer')),
          ],
        ),
      ),
    );
  }
}