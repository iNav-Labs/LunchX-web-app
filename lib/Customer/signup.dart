// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:lunchx_order/Customer/login.dart';

import 'package:lunchx_order/Customer/student_dashboard.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key}); // Fixed the constructor syntax

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp _phoneNumberRegExp = RegExp(r'^[0-9]{10}$');
  bool _loading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(80.0, 50.0, 80.0, 98.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Email ID Here ...',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Set Your Password Here ...',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: Text(
                        'Already User? Login',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    FloatingActionButton.small(
                      backgroundColor: Colors.black,
                      onPressed: _loading ? null : () {
                        _registerUser(context);
                      },
                      shape: const StadiumBorder(),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(
                              Icons.arrow_right_alt_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/bowl.jpeg',
                    fit: BoxFit.cover,
                    height: 200.0,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser(BuildContext context) async {
    setState(() {
      _loading = true; // Set loading state to true
    });
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final email = _emailController.text;

      // Validate email format
      if (!_emailRegExp.hasMatch(email)) {
        throw 'Invalid email format';
      }

      // Check if email is already used
      final emailQuerySnapshot = await FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('users')
          .doc(email)
          .get();

      if (emailQuerySnapshot.exists) {
        throw 'Email already exists';
      }

      // Add data to Firestore
      await FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('users')
          .doc(email)
          .set({
        'email': email,
        'name': _nameController.text,
        'address': _addressController.text,
        'phoneNumber': _phoneController.text,
      });

      // Navigate to DashboardScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    } finally {
      setState(() {
        _loading = false; // Set loading state to false
      });
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
