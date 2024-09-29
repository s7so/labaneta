import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/components/custom_app_bar.dart';
import 'package:labaneta_sweet/components/custom_button.dart';
import 'package:labaneta_sweet/utils/constants.dart';
import 'package:labaneta_sweet/providers/cart_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  String _paymentMethod = 'Credit Card';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Checkout'),
      body: Stack(
        children: [
          _buildBackgroundDecoration(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(Constants.paddingMedium),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Personal Information'),
                  _buildPersonalInfoFields(),
                  _buildSectionTitle('Payment Method'),
                  _buildPaymentMethodSelector(),
                  _buildSectionTitle('Order Summary'),
                  _buildOrderSummary(cartProvider),
                  const SizedBox(height: Constants.paddingLarge),
                  _buildPlaceOrderButton(cartProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecoration() {
    return Positioned.fill(
      child: SvgPicture.asset(
        'assets/images/checkout_background.svg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.paddingMedium),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoFields() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(Constants.paddingMedium),
        child: Column(
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
            ),
            const SizedBox(height: Constants.paddingMedium),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter your email';
                if (!value!.contains('@')) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: Constants.paddingMedium),
            _buildTextField(
              controller: _addressController,
              label: 'Delivery Address',
              icon: Icons.location_on,
              validator: (value) => value?.isEmpty ?? true ? 'Please enter your address' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(Constants.paddingMedium),
        child: DropdownButtonFormField<String>(
          value: _paymentMethod,
          items: ['Credit Card', 'PayPal', 'Cash on Delivery']
              .map((method) => DropdownMenuItem(
                    value: method,
                    child: Row(
                      children: [
                        Icon(_getPaymentIcon(method), color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(width: Constants.paddingSmall),
                        Text(method),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _paymentMethod = value!),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'Credit Card':
        return Icons.credit_card;
      case 'PayPal':
        return Icons.payment;
      case 'Cash on Delivery':
        return Icons.local_shipping;
      default:
        return Icons.payment;
    }
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(Constants.paddingMedium),
        child: Column(
          children: [
            ...cartProvider.items.values.map(_buildOrderItem),
            const Divider(),
            _buildTotalRow(cartProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(item.product.imageUrl)),
      title: Text(item.product.name),
      subtitle: Text('${item.quantity}x \$${item.product.price.toStringAsFixed(2)}'),
      trailing: Text('\$${(item.quantity * item.product.price).toStringAsFixed(2)}'),
    );
  }

  Widget _buildTotalRow(CartProvider cartProvider) {
    return ListTile(
      title: Text('Total', style: Theme.of(context).textTheme.titleMedium),
      trailing: Text(
        '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget _buildPlaceOrderButton(CartProvider cartProvider) {
    return CustomButton(
      text: 'Place Order',
      onPressed: () => _placeOrder(cartProvider),
    );
  }

  void _placeOrder(CartProvider cartProvider) {
    if (_formKey.currentState!.validate()) {
      // TODO: Process the order
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order placed successfully!'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      cartProvider.clear();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}