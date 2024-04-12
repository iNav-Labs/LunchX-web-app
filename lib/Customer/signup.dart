import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchx_order/Customer/login.dart';
import 'package:lunchx_order/Customer/student_dashboard.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6552FE), // Purple color
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black, // Black color
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black, // Black color
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Sign',
                        style: GoogleFonts.outfit(
                          fontSize: 36.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6552FE),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'Up',
                        style: GoogleFonts.outfit(
                          fontSize: 36.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 2, color: Colors.black),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle:
                        GoogleFonts.outfit(color: Colors.grey, fontSize: 14.0),
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never, // Remove label text on tap
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 2, color: Colors.black),
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Set Your Password Here ...',
                    labelStyle:
                        GoogleFonts.outfit(color: Colors.grey, fontSize: 14.0),
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
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never, // Remove label text on tap
                  ),
                  obscureText: _obscurePassword,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 2, color: Colors.black),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle:
                        GoogleFonts.outfit(color: Colors.grey, fontSize: 14.0),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never, // Remove label text on tap
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 2, color: Colors.black),
                ),
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle:
                        GoogleFonts.outfit(color: Colors.grey, fontSize: 14.0),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never, // Remove label text on tap
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 2, color: Colors.black),
                ),
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle:
                        GoogleFonts.outfit(color: Colors.grey, fontSize: 14.0),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never, // Remove label text on tap
                  ),
                  keyboardType: TextInputType.phone,
                ),
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
                  FloatingActionButton(
  backgroundColor: Colors.black,
  onPressed: _loading
      ? null
      : () {
          _registerUser(context);
        },
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  child: _loading
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        )
      : Image.asset(
          'assets/Arrow.png', // Provide the path to your image asset
          width: 30,
          height: 30,
          color: Colors.white,
        ),
),

                ],
              ),
              const SizedBox(height: 30.0),
            Image.asset(
  'assets/bowl.jpeg',
  fit: BoxFit.cover,
  height: MediaQuery.of(context).size.height / 4, // Adjust the fraction as needed
  width:  MediaQuery.of(context).size.width /2, // Adjust the fraction as needed
),
            ],
          ),
        ),
      ),
    );
  }

  void _registerUser(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final email = _emailController.text;

      if (!_emailRegExp.hasMatch(email)) {
        throw 'Invalid email format';
      }

      final emailQuerySnapshot = await FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('users')
          .doc(email)
          .get();

      if (emailQuerySnapshot.exists) {
        throw 'Email already exists';
      }

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    } finally {
      setState(() {
        _loading = false;
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
