import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/components/custom_app_bar.dart';
import 'package:labaneta_sweet/components/custom_button.dart';
import 'package:labaneta_sweet/providers/cart_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:labaneta_sweet/screens/checkout_screen.dart';
import 'package:labaneta_sweet/screens/menu_screen.dart'; // Add this import
import '../providers/loyalty_provider.dart';
import '../models/loyalty_program.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Your Cart'),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return cart.items.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartContent(context, cart);
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i) => CartItemCard(
              cartItem: cart.items.values.toList()[i],
              productId: cart.items.keys.toList()[i],
            ),
          ),
        ),
        CartSummary(
          totalAmount: cart.totalAmount,
          itemCount: cart.itemCount,
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context, CartProvider cartProvider) {
    final loyaltyProvider = Provider.of<LoyaltyProvider>(context, listen: false);
    return CustomButton(
      text: 'Place Order',
      onPressed: () {
        // Process the order
          final orderTotal = cartProvider.totalAmount;
          final earnedPoints = LoyaltyProgram.calculatePointsForPurchase(orderTotal);
          loyaltyProvider.addPoints(earnedPoints);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order placed successfully! You earned $earnedPoints points.'),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
          cartProvider.clear();
          Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final String productId;

  const CartItemCard({
    Key? key,
    required this.cartItem,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(productId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _removeItem(context),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: _buildPriceAvatar(),
            title: Text(cartItem.product.name),
            subtitle: Text('Total: \$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
            trailing: _buildQuantityControls(context),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceAvatar() {
    return CircleAvatar(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: FittedBox(
          child: Text('\$${cartItem.product.price.toStringAsFixed(2)}'),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => _decreaseQuantity(context),
        ),
        Text('${cartItem.quantity}x'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _increaseQuantity(context),
        ),
      ],
    );
  }

  void _removeItem(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false).removeItem(productId);
  }

  void _decreaseQuantity(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false).removeSingleItem(productId);
  }

  void _increaseQuantity(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false).addItem(cartItem.product);
  }
}

class CartSummary extends StatelessWidget {
  final double totalAmount;
  final int itemCount;

  const CartSummary({
    Key? key,
    required this.totalAmount,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTotalRow(context),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Proceed to Checkout',
            onPressed: () => _navigateToCheckout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total ($itemCount items):',
          style: theme.textTheme.titleMedium,
        ),
        Text(
          '\$${totalAmount.toStringAsFixed(2)}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _navigateToCheckout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckoutScreen()),
    );
  }
}