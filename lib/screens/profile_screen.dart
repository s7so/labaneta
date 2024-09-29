import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/components/custom_app_bar.dart';
import 'package:labaneta_sweet/components/custom_button.dart';
import 'package:labaneta_sweet/utils/constants.dart';
import 'package:labaneta_sweet/providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: ListView(
        padding: const EdgeInsets.all(Constants.paddingMedium),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue, // Replace with your theme color
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: Constants.paddingLarge),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Constants.paddingSmall),
          Text(
            'johndoe@example.com',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Constants.paddingLarge),
          _buildProfileOption(context, 'Edit Profile', Icons.edit),
          _buildProfileOption(context, 'Order History', Icons.history),
          _buildProfileOption(context, 'Payment Methods', Icons.payment),
          _buildProfileOption(context, 'Address Book', Icons.location_on),
          _buildProfileOption(context, 'Settings', Icons.settings),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          const SizedBox(height: Constants.paddingLarge),
          CustomButton(
            text: 'Log Out',
            onPressed: () {
              // TODO: Implement log out functionality
            },
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.secondary),
      onTap: () {
        // TODO: Navigate to respective screens
      },
    );
  }
}