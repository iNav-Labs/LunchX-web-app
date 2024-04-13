import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lunchx_order/Customer/signup.dart';
import 'package:lunchx_order/Customer/student_dashboard.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
          Row(
  children: [
    Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF6552FE), // Purple color
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
    Spacer(), // Adds space between the dots and the "Log in" text
   Row(
                    children: [
                      Text(
                        'Log',
                        style: GoogleFonts.outfit(
                          fontSize: 36.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6552FE),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'in',
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
                    labelText: 'Your Password',
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
                      const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: const Text(
                        'New User? Sign Up',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: _isLoading ? null : () => _loginUser(context),
                     backgroundColor: Colors.black,
                        child: _isLoading
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
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
  'assets/bowl2.jpeg',
  fit: BoxFit.cover,
  height: MediaQuery.of(context).size.height / 4, // Adjust the fraction as needed
  width:  MediaQuery.of(context).size.width /2, // Adjust the fraction as needed
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
      _isLoading = true;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
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
