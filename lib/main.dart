import 'package:draw_auth/pages/cart_page.dart';
import 'package:draw_auth/pages/checkout_page.dart';
import 'package:draw_auth/viewmodels/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'viewmodels/products_viewmodel.dart';
import 'package:draw_auth/pages/products_page.dart';
import 'package:draw_auth/pages/single_products_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
// 🔥 AJOUT : Import Firebase Core pour initialiser Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ProductsPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          },
        ),
        GoRoute(
          path: 'product/:id',
          builder: (BuildContext context, GoRouterState state) {
            return ProductDetailPage(productId: int.parse(state.pathParameters['id']!));
          },
        ),
        GoRoute(
          path: 'cart',
          builder: (BuildContext context, GoRouterState state) {
            return const CartPage();
          },
        )
      ],
    ),
  ],
);

// 🔥 MODIFICATION : Fonction main() maintenant asynchrone
void main() async {
  // 🔥 AJOUT : Initialise les bindings Flutter (requis avant Firebase)
  WidgetsFlutterBinding.ensureInitialized();
  // 🔥 AJOUT : Initialise Firebase avant de lancer l'app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        // Ajouter d'autres ViewModels ici
      ],
      child: MaterialApp.router(
        title: 'Mon App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: _router,
      ),
    );
  }
}
