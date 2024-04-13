// ignore_for_file: unused_local_variable, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lunchx_order/Canteen/canteen_dashboard.dart';
import 'package:lunchx_order/Canteen/canteensignup.dart';
// import 'package:lunchx_order/Canteen/canteensignup.dart';

class CanteenLogin extends StatefulWidget {
  const CanteenLogin({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<CanteenLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;
  bool _isLoading = false; // Track loading state

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
                  'Canteen Login',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Registered Email ID',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Password',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CanteenSignUp(),
                          ),
                        );
                      },
                      child: const Text(
                        'New User? Sign Up',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    FloatingActionButton.small(
                      backgroundColor: Colors.black,
                      onPressed: _isLoading ? null : () => _loginUser(context), // Disable button when loading
                      shape: const StadiumBorder(),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
                          ) // Show loader when loading
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
                    'assets/bowl2.jpeg',
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

  void _loginUser(BuildContext context) async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If login successful, navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardCanteen()),
      );
    } catch (e) {
      // If login fails, show alert
      _showErrorDialog(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
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
