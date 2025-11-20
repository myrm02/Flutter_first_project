import 'package:web' as html;
import 'dart:js_interop 'as js;
import 'package:flutter/material.dart';

class InstallPwaButton extends StatefulWidget {
  @override
  _InstallPwaButtonState createState() => _InstallPwaButtonState();
}

class _InstallPwaButtonState extends State<InstallPwaButton> {
  html.BeforeInstallPromptEvent? installEvent;

  @override
  void initState() {
    super.initState();
    html.window.addEventListener('beforeinstallprompt', (event) {
      event.preventDefault();
      setState(() {
        installEvent = event as html.BeforeInstallPromptEvent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (installEvent == null) return SizedBox.shrink();

    return ElevatedButton(
      child: Text("Installer l'application"),
      onPressed: () async {
        await installEvent!.prompt();
      },
    );
  }
}
