// ignore_for_file: prefer_const_literals_to_create_immutables, library_private_types_in_public_api, avoid_unnecessary_containers

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchx_order/Customer/student_dashboard.dart';

class PaymentFail extends StatefulWidget {
  const PaymentFail({super.key});

  @override
  _PaymentFailState createState() => _PaymentFailState();
}

class _PaymentFailState extends State<PaymentFail> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const DashboardScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 100),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF5252), // Red
              Color(0xFFFF5252), // Red
              Color(0xFF6552FE), // Purple
              Color(0xFF6552FE), // Purple
            ],
            stops: [0, 1 / 3, 2 / 3, 1],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                'Payment Failed',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(height: 20), // Add space between text and image
              Image.asset(
                'assets/fail.gif',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20), // Add space between image and text
              Text(
                'Your payment failed. Please try again.',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40), // Add space between text and logo
              Image.asset(
                'assets/logo.png',
                width: 120,
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
