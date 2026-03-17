import 'package:flutter/material.dart';
import 'package:ircell/login/widget_tree.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 4));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const WidgetTree()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: Center(
        child: Image.asset(
          'assets/images/splash.gif',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
