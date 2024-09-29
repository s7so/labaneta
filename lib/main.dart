import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/utils/app_theme.dart';
import 'package:labaneta_sweet/screens/home_screen.dart';
import 'package:labaneta_sweet/providers/product_provider.dart';
import 'package:labaneta_sweet/providers/cart_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Labanita Sweets',
        theme: ThemeData(
          fontFamily: 'Raleway',
          // Use other theme properties from AppTheme
          primaryColor: AppTheme.primaryColor,
          scaffoldBackgroundColor: AppTheme.backgroundColor,
          appBarTheme: AppTheme.theme.appBarTheme,
          elevatedButtonTheme: AppTheme.theme.elevatedButtonTheme,
          textTheme: AppTheme.textTheme,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
