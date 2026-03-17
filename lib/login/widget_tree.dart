import 'package:flutter/material.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/login/login_page.dart';
import 'package:ircell/screens/tabs_screen.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TabsScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
