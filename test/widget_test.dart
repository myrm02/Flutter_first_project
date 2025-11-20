// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:draw_auth/pages/products_page.dart';
import 'package:draw_auth/pages/register_page.dart';
import 'package:draw_auth/pages/single_products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_router/go_router.dart';
import 'package:draw_auth/main.dart';

void main() {
  testWidgets('Create a user through registration and display homepage', (WidgetTester tester) async {
    
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const ProductsPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (_, __) => const RegisterPage(),
        )
      ],
    );
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    router.go('/register');

    await tester.pumpAndSettle();
    
    await tester.tap(find.byIcon(Icons.email));
    await tester.pump();
    await tester.enterText(
      find.widgetWithIcon(TextFormField, Icons.email),
      'user@example.com',
    );
    await tester.pump();
    await tester.tap(find.byIcon(Icons.lock));
    await tester.enterText(
      find.widgetWithIcon(TextFormField, Icons.lock),
      'Password123',
    );
    await tester.pump();
    await tester.tap(find.byIcon(Icons.lock_outline));
    await tester.enterText(
      find.widgetWithIcon(TextFormField, Icons.lock_outline),
      'Password123',
    );
    await tester.pump();
    await tester.tap(find.text('S\'inscrire'));
    await tester.pump();

    router.go('/');

    // 5. Termine le routing
    await tester.pumpAndSettle();

    // 6. Vérifie que la page principale est affichée
    expect(find.byType(ProductsPage), findsOneWidget);

  });

  testWidgets('Go to product details page from homepage', (WidgetTester tester) async {
    
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const ProductsPage(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (_, state) =>
              ProductDetailPage(productId: int.parse(state.pathParameters['id']!)),
        ),
      ],
    );
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    router.go('/');

    // 5. Termine le routing
    await tester.pumpAndSettle();

    // 6. Vérifie que la page principale est affichée
    expect(find.byType(ProductsPage), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    // Naviguer vers /product/1
    router.go('/product/1');

    await tester.pumpAndSettle();

    // Vérifier que la page de détail des produits s'affiche correctement
    expect(find.byType(ProductDetailPage), findsOneWidget);
    
    });
}
