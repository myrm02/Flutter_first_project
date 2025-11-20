import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../widgets/pwa.dart';

class InstallPwaPage extends StatelessWidget {
  const InstallPwaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Installer l\'application en version Desktop')),
      drawer: const AppDrawer(),
      body: const Center(child: InstallPwaWidget()),
    );
  }
}