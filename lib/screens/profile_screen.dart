import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/auth_provider.dart';
import 'package:labaneta_sweet/screens/auth_screen.dart';
import 'package:labaneta_sweet/components/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: Provider.of<AuthProvider>(context, listen: false).userData?['name']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        String? photoURL;
        if (_image != null) {
          final ref = FirebaseStorage.instance.ref().child('user_photos').child('${DateTime.now().toIso8601String()}.jpg');
          await ref.putFile(_image!);
          photoURL = await ref.getDownloadURL();
        }

        await Provider.of<AuthProvider>(context, listen: false).updateProfile(
          name: _nameController.text,
          photoURL: photoURL,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null 
                    ? FileImage(_image!) 
                    : (userData?['photoURL'] != null 
                        ? NetworkImage(userData!['photoURL']) 
                        : null) as ImageProvider?,
                child: _image == null && userData?['photoURL'] == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Update Profile',
                    onPressed: _updateProfile,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Email: ${userData?['email'] ?? ''}'),
            Text('Loyalty Points: ${userData?['loyaltyPoints'] ?? 0}'),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Log Out',
              onPressed: () async {
                await authProvider.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (route) => false,
                );
              },
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
}