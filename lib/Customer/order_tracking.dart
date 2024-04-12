import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lunchx_order/Customer/oder_tracking_details.dart';
import 'package:lunchx_order/Customer/student_dashboard.dart';

class OrderTracker extends StatefulWidget {
  const OrderTracker({Key? key}) : super(key: key);

  @override
  _OrderTrackerState createState() => _OrderTrackerState();
}

class _OrderTrackerState extends State<OrderTracker> {
  bool _isLoading = false; // Variable to track whether data is being fetched

  // Function to handle refresh button press
  void handleRefresh() {
    // Set _isLoading to true when refresh button is pressed
    setState(() {
      _isLoading = true;
    });

    // Simulating data fetching using Timer
    Timer(Duration(seconds: 2), () {
      // After data fetching is completed, set _isLoading back to false
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth =
        MediaQuery.of(context).size.width - 20.0; // Full width of the card
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6552FE),
        elevation: 10, // Removes the shadow
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        title: Text(
          'Order Tracking',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Pop all routes until reaching the first route
            Navigator.popUntil(context, (route) => route.isFirst);

            // Push the student_dashboard screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardScreen(),
              ),
            );
          },
        ),
        // Conditionally display refresh button or circular progress indicator
        actions: [
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white),
                  onPressed: handleRefresh,
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // START COOKING CARDS
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: OrderDetailsCard(
                        cardWidth: MediaQuery.of(context).size.width,
                      ),
                    ),
            ),
            // END COOKING CARDS
          ],
        ),
      ),
    );
  }
}
