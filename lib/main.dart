import 'package:flutter/material.dart';
import 'package:ircell/login/splash_screen.dart';
import 'package:ircell/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WebViewPlatform.instance = AndroidWebViewPlatform();
  await ThemeController.loadThemeMode();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'IR CELL',
          theme: AppTheme.buildTheme(Brightness.light),
          darkTheme: AppTheme.buildTheme(Brightness.dark),
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}