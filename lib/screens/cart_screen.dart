import 'package:flutter/material.dart';
import 'package:labaneta_sweet/components/custom_app_bar.dart';
import 'package:labaneta_sweet/components/custom_button.dart';
import 'package:labaneta_sweet/utils/app_theme.dart';
import 'package:labaneta_sweet/utils/constants.dart';
// Remove or comment out this line if CheckoutScreen doesn't exist yet
// import 'package:labaneta_sweet/screens/checkout_screen.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Cart'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items.values.toList()[index];
                return CartItem(
                  name: item.product.name,
                  price: item.product.price,
                  quantity: item.quantity,
                  onIncrease: () => cartProvider.addItem(item.product),
                  onDecrease: () => cartProvider.decreaseQuantity(item.product.id),
                  onRemove: () => cartProvider.removeItem(item.product.id),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Constants.paddingMedium),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: AppTheme.textTheme.titleLarge,
                    ),
                    Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: AppTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Proceed to Checkout',
                  onPressed: () {
                    // Temporarily comment out or remove this navigation
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                    // );
                    // Add a placeholder action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checkout functionality coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String name;
  final double price;
  final int quantity;
  final Function onIncrease;
  final Function onDecrease;
  final Function onRemove;

  const CartItem({
    Key? key,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('\$${price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              onDecrease();
            },
          ),
          Text('$quantity'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              onIncrease();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onRemove();
            },
          ),
        ],
      ),
    );
  }
}