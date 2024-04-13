import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchx_order/Customer/student_dashboard.dart'; // Import the dashboard screen

class RefundProcessingScreen extends StatelessWidget {
  const RefundProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevents the user from going back
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF38B6FF), // blue
                Color(0xFF38B6FF), // blue
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
                  'Refund Processing',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 30.0,
                  ),
                ),
                const SizedBox(height: 20), // Add space between text and image
                Image.asset(
                  'assets/refund.gif', // Assuming you have a refund processing animation
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20), // Add space between image and text
                Text(
                  'Your refund will be processed in the next 7 working days.',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40), // Add space between text and button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const DashboardScreen(), // Navigate to the dashboard screen
                      ),
                    );
                  },
                  child: const Text(
                    'Go to Dashboard',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
