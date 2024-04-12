import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lunchx_order/Customer/landingpage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunchx_order/Canteen/canteen_dashboard.dart';
import 'package:lunchx_order/Customer/student_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkUserRole(),
      builder: (context, AsyncSnapshot<UserRole?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
         return Scaffold(
  backgroundColor: const Color(0xFF6552FE),
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logo.png', // Adjust the path accordingly
          width: 250.0, // Adjust the size of the image
          height: 250.0,
        ),
        const SizedBox(height: 20.0),
        const SizedBox(
          width: 30,
          height: 30,
         child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    ),
  ),
);


        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.data == UserRole.canteen) {
          return DashboardCanteen(); // Navigate to canteen dashboard
        } else if (snapshot.data == UserRole.customer) {
          return DashboardScreen(); // Navigate to customer dashboard
        } else {
          return LandingPage(); // Navigate to customer login page if not a canteen or customer
        }
      },
    );
  }

  Future<UserRole?> _checkUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    String userEmail = user.email!;
    
    // Check if the user email exists in the "canteens" collection
    DocumentSnapshot<Map<String, dynamic>> canteenSnapshot = await FirebaseFirestore.instance
        .collection('LunchX')
        .doc('canteens')
        .collection('users')
        .doc(userEmail)
        .get();

    if (canteenSnapshot.exists) {
      return UserRole.canteen;
    }

    // Check if the user email exists in the "customers" collection
    DocumentSnapshot<Map<String, dynamic>> customerSnapshot = await FirebaseFirestore.instance
        .collection('LunchX')
        .doc('customers')
        .collection('users')
        .doc(userEmail)
        .get();

    if (customerSnapshot.exists) {
      return UserRole.customer;
    }

    // If the user email doesn't belong to canteen or customer, default to customer login
    return UserRole.customer;
  }
}

enum UserRole {
  canteen,
  customer,
}