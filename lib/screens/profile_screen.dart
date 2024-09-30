import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/components/custom_app_bar.dart';
import 'package:labaneta_sweet/components/custom_button.dart';
import 'package:labaneta_sweet/utils/constants.dart';
import 'package:labaneta_sweet/providers/theme_provider.dart';
import 'package:labaneta_sweet/providers/loyalty_provider.dart';
import 'package:labaneta_sweet/screens/loyalty_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loyaltyProvider = Provider.of<LoyaltyProvider>(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
              _confettiController.play();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(primaryColor, secondaryColor),
                  const SizedBox(height: Constants.paddingLarge),
                  _buildLoyaltyCard(context, loyaltyProvider),
                  const SizedBox(height: Constants.paddingLarge),
                  _buildSectionTitle('Account Settings'),
                  _buildProfileOptions(context, primaryColor, secondaryColor),
                  const SizedBox(height: Constants.paddingLarge),
                  _buildSectionTitle('Preferences'),
                  _buildPreferencesOptions(context, primaryColor, secondaryColor, themeProvider),
                  const SizedBox(height: Constants.paddingLarge),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
          _buildConfetti(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: BackgroundPainter(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              animation: _animation,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Color primaryColor, Color secondaryColor) {
    return Center(
      child: Column(
        children: [
          Hero(
            tag: 'profile_picture',
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + (_animation.value * 0.1),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: Constants.paddingMedium),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: Constants.paddingSmall),
          Text(
            'johndoe@example.com',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: secondaryColor),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildLoyaltyCard(BuildContext context, LoyaltyProvider loyaltyProvider) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoyaltyScreen())),
      child: Container(
        padding: const EdgeInsets.all(Constants.paddingMedium),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Loyalty Program',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            const SizedBox(height: Constants.paddingSmall),
            Text(
              '${loyaltyProvider.points} Points',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Constants.paddingSmall),
            Text(
              'Tap to view rewards',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms, delay: 400.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.paddingSmall),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildProfileOptions(BuildContext context, Color primaryColor, Color secondaryColor) {
    final options = [
      {'title': 'Edit Profile', 'icon': Icons.edit, 'onTap': () {}},
      {'title': 'Order History', 'icon': Icons.history, 'onTap': () {}},
      {'title': 'Payment Methods', 'icon': Icons.payment, 'onTap': () {}},
      {'title': 'Address Book', 'icon': Icons.location_on, 'onTap': () {}},
      {'title': 'Notifications', 'icon': Icons.notifications, 'onTap': () {}},
    ];

    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        return _buildOptionTile(
          context,
          option['title'] as String,
          option['icon'] as IconData,
          option['onTap'] as VoidCallback,
          primaryColor,
          secondaryColor,
        ).animate().fadeIn(duration: 600.ms, delay: Duration(milliseconds: 200 * index)).slideX(begin: 0.2, end: 0);
      }).toList(),
    );
  }

  Widget _buildPreferencesOptions(BuildContext context, Color primaryColor, Color secondaryColor, ThemeProvider themeProvider) {
    return Column(
      children: [
        _buildSwitchTile(
          context,
          'Dark Mode',
          Icons.dark_mode,
          themeProvider.isDarkMode,
          (value) => themeProvider.toggleTheme(),
          primaryColor,
          secondaryColor,
        ),
        _buildSwitchTile(
          context,
          'Notifications',
          Icons.notifications_active,
          true,
          (value) {/* TODO: Implement notifications toggle */},
          primaryColor,
          secondaryColor,
        ),
      ],
    );
  }

  Widget _buildOptionTile(BuildContext context, String title, IconData icon, VoidCallback onTap, Color primaryColor, Color secondaryColor) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: secondaryColor),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: primaryColor)),
      trailing: Icon(Icons.chevron_right, color: secondaryColor),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, IconData icon, bool value, ValueChanged<bool> onChanged, Color primaryColor, Color secondaryColor) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: secondaryColor),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: primaryColor)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: secondaryColor,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: CustomButton(
        text: 'Log Out',
        onPressed: () {
          // TODO: Implement log out functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logged out successfully')),
          );
        },
        isOutlined: true,
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 800.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildConfetti() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirection: pi / 2,
        maxBlastForce: 5,
        minBlastForce: 1,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.05,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;

  BackgroundPainter({required this.color, required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final y1 = sin(animation.value * 2 * pi) * size.height / 4 + size.height / 2;
    final y2 = cos(animation.value * 2 * pi) * size.height / 4 + size.height / 2;

    path.moveTo(0, y1);
    path.quadraticBezierTo(size.width / 2, y2, size.width, y1);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}