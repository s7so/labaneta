import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:labaneta_sweet/providers/cart_provider.dart';
import 'package:labaneta_sweet/providers/product_provider.dart';
import 'package:labaneta_sweet/providers/theme_provider.dart';
import 'package:labaneta_sweet/providers/loyalty_provider.dart';
import 'package:labaneta_sweet/screens/home_screen.dart';
import 'package:labaneta_sweet/theme/app_theme.dart';
import 'package:labaneta_sweet/providers/auth_provider.dart';
import 'package:labaneta_sweet/screens/auth_screen.dart';
import 'package:labaneta_sweet/providers/favorites_provider.dart';
import 'package:labaneta_sweet/providers/notification_provider.dart';
import 'package:labaneta_sweet/providers/review_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoyaltyProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labanita Sweets',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.user == null) {
            return const AuthScreen();
          } else {
            return const HomeScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}