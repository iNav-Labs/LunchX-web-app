// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunchx_order/Customer/student_dashboard.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({Key? key}) : super(key: key);

  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final RegExp _phoneNumberRegExp = RegExp(r'^[0-9]{10}$');
  bool _loading = false;

  Future<void> _registerUser(BuildContext context) async {
    setState(() {
      _loading = true; // Show loader
    });

    try {
      final phoneNumber = _phoneController.text;
      User? user = FirebaseAuth.instance.currentUser;
      String? userEmail = user?.email;

      if (!_phoneNumberRegExp.hasMatch(phoneNumber)) {
        throw 'Invalid phone number format';
      }
      
      await FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('users')
          .doc(userEmail)
          .set({
        'name': _nameController.text,
        'address': _addressController.text,
        'phoneNumber': phoneNumber,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('User Registration'),
            content: const Text('Your user registration is successfully done.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to store data: $e'),
            actions: <Widget>[
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
    } finally {
      setState(() {
        _loading = false; // Hide loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Registration',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton.small(
                        backgroundColor: Colors.black,
                        onPressed: _loading ? null : () {
                          _registerUser(context);
                        },
                        shape: const StadiumBorder(),
                        child: _loading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
