// ignore_for_file: unused_local_variable, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lunchx_order/Canteen/canteen_registration.dart';
import 'package:lunchx_order/Canteen/canteenlogin.dart';
import 'package:lunchx_order/Customer/login.dart';

class CanteenSignUp extends StatefulWidget {
  const CanteenSignUp({super.key});

  @override
  _CanteenSignUpState createState() => _CanteenSignUpState();
}

class _CanteenSignUpState extends State<CanteenSignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;

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
                  'Canteen Sign Up',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CanteenLogin(),
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
                      onPressed: () {
                        _registerWithEmailAndPassword(context);
                      },
                      shape: const StadiumBorder(),
                      child: const Icon(
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

  void _registerWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      _showSignUpSuccessDialog(context);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showSignUpSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Up'),
          content: const Text('You have successfully signed up.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CanteenRegistration(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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