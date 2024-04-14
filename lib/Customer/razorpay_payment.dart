import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lunchx_order/Customer/payment_done.dart';
import 'package:lunchx_order/Customer/payment_fail.dart';
import 'package:razorpay_web/razorpay_web.dart';

class RazorPayPage extends StatefulWidget {
  final double orderAmount; // Receive order amount as parameter
  final Function() onPaymentSuccess; // Callback function for successful payment

  const RazorPayPage({
    super.key,
    required this.orderAmount,
    required this.onPaymentSuccess,
    required Null Function() onPaymentFail,
  });

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  late Razorpay _razorpay;
  User? user = FirebaseAuth.instance.currentUser;
    

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    openCheckout();
  }
  static Future<String?> getPhoneNumber() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        // Extract the email of the current user
        String email = user.email ?? "";

        final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('LunchX')
            .doc('customers')
            .collection('users')
            .doc(email)
            .get();

        if (docSnapshot.exists) {
          final phoneNumber = docSnapshot.get('phoneNumber');
          return phoneNumber.toString();
        } else {
          return null; // Document does not exist
        }
      } else {
        return null; // User not signed in
      }
    } catch (e) {
      print('Error fetching phone number: $e');
      return null;
    }
  }
  final phoneNum = getPhoneNumber();


  void openCheckout() async {
    int amountInPaise = (widget.orderAmount * 100).toInt();
    var options = {
      'key': 'rzp_test_3XYau8mY6BkJq6',
      'amount': amountInPaise,
      'name': 'LunchX',
      'prefill': { 'email': '${user!.email}'},
      'timeout': 90,
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successful: ${response.paymentId}",
        toastLength: Toast.LENGTH_SHORT);
    // Navigate to payment success screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PaymentSuccess()),
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Failed: ${response.message} - ${response.code}",
        toastLength: Toast.LENGTH_SHORT);
    // Navigate to payment fail screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PaymentFail()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
     body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Payment page is loading...',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 20),
      CircularProgressIndicator(), // Placeholder for loading indicator
      SizedBox(height: 10),
      Text(
        'If this takes longer than usual, the payment will be canceled.\nPlease try placing the order again.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    ],
  ),
     ),
     );
  }
}
