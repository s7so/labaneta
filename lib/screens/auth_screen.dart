import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/auth_provider.dart';
import 'package:labaneta_sweet/components/custom_text_field.dart';
import 'package:labaneta_sweet/components/custom_button.dart';
import 'package:labaneta_sweet/utils/validators.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  late RiveAnimationController _riveController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _riveController = SimpleAnimation('idle');
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }


  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildLogo(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLoginForm(),
                      _buildSignUpForm(),
                      _buildForgotPasswordForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: RiveAnimation.asset(
        'assets/animations/background.riv',
        fit: BoxFit.cover,
        controllers: [_riveController],
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Image.asset(
        'assets/images/logo.jpg',
        height: 120,
      ).animate().fadeIn(duration: 600.ms).scale(delay: 300.ms),
    );
  }

  Widget _buildLoginForm() {
    return _buildForm(
      title: 'Login',
      fields: [
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email,
          validator: Validators.validateEmail,
        ),
        CustomTextField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock,
          obscureText: _obscurePassword,
          validator: Validators.validatePassword,
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
      ],
      button: CustomButton(
        text: 'Login',
        onPressed: _handleLogin,
        isLoading: _isLoading,
      ),
      bottomText: "Don't have an account?",
      bottomAction: TextButton(
        child: const Text('Sign Up'),
        onPressed: () => _tabController.animateTo(1),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return _buildForm(
      title: 'Sign Up',
      fields: [
        CustomTextField(
          controller: _nameController,
          label: 'Full Name',
          icon: Icons.person,
          validator: Validators.validateName,
        ),
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email,
          validator: Validators.validateEmail,
        ),
        CustomTextField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock,
          obscureText: _obscurePassword,
          validator: Validators.validatePassword,
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
      ],
      button: CustomButton(
        text: 'Sign Up',
        onPressed: _handleSignUp,
        isLoading: _isLoading,
      ),
      bottomText: "Already have an account?",
      bottomAction: TextButton(
        child: const Text('Login'),
        onPressed: () => _tabController.animateTo(0),
      ),
    );
  }

  Widget _buildForgotPasswordForm() {
    return _buildForm(
      title: 'Forgot Password',
      fields: [
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email,
          validator: Validators.validateEmail,
        ),
      ],
      button: CustomButton(
        text: 'Reset Password',
        onPressed: _handleResetPassword,
        isLoading: _isLoading,
      ),
      bottomText: "Remember your password?",
      bottomAction: TextButton(
        child: const Text('Login'),
        onPressed: () => _tabController.animateTo(0),
      ),
    );
  }

  Widget _buildForm({
    required String title,
    required List<Widget> fields,
    required Widget button,
    required String bottomText,
    required Widget bottomAction,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 32),
            ...fields.map((field) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: field.animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
            )),
            const SizedBox(height: 16),
            button.animate().fadeIn(duration: 600.ms).scale(delay: 300.ms),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(bottomText),
                bottomAction,
              ],
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
            if (_tabController.index != 2)
              TextButton(
                child: const Text('Forgot Password?'),
                onPressed: () => _tabController.animateTo(2),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await Provider.of<AuthProvider>(context, listen: false).login(
          _emailController.text,
          _passwordController.text,
        );
        // Navigate to home screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await Provider.of<AuthProvider>(context, listen: false).signUp(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );
        // Navigate to home screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await Provider.of<AuthProvider>(context, listen: false).resetPassword(
          _emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent. Check your inbox.')),
        );
        _tabController.animateTo(0);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}