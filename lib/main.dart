import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/cart_provider.dart';
import 'package:labaneta_sweet/providers/product_provider.dart';
import 'package:labaneta_sweet/providers/theme_provider.dart';
import 'package:labaneta_sweet/providers/loyalty_provider.dart';
import 'package:labaneta_sweet/screens/home_screen.dart';
import 'package:labaneta_sweet/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoyaltyProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Labanita Sweets',
          theme: AppTheme.lightTheme,
          // We'll remove the darkTheme for now since it's not defined
          // darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light, // Always use light theme for now
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
