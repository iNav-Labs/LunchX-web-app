// ignore_for_file: prefer_const_literals_to_create_immutables, library_private_types_in_public_api, avoid_unnecessary_containers

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lunchx_order/Customer/order_tracking.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}
class _PaymentSuccessState extends State<PaymentSuccess> {
  List<Map<String, dynamic>> order = [];
  @override
  void initState() {
    super.initState();
    fetchOrderData();
    confirmOrder(context);
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const OrderTracker(),
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
  Future<void> fetchOrderData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? userEmail = user?.email;

      if (userEmail != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('LunchX')
            .doc('customers')
            .collection('users')
            .doc(userEmail)
            .collection('cart')
            .get();

        List<Map<String, dynamic>> fetchedOrderList = [];
        for (var doc in querySnapshot.docs) {
          fetchedOrderList.add(doc.data() as Map<String, dynamic>);
        }

        setState(() {
          order = fetchedOrderList;
        });
      }
    } catch (e) {
      // Handle any errors that occur
    }
  }
Future<String?> getCanteenOwnerEmail(String canteenName) async {
  try {
    // Get the reference to the 'users' collection under 'canteens' in 'LunchX'
    CollectionReference usersCollectionRef = FirebaseFirestore.instance
        .collection('LunchX')
        .doc('canteens')
        .collection('users');

    // Fetch all documents from the 'users' collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await usersCollectionRef.get() as QuerySnapshot<Map<String, dynamic>>;

    // Iterate through each document to find a match for canteenName
    for (QueryDocumentSnapshot<Map<String, dynamic>> userDoc
        in querySnapshot.docs) {
      // Get the data map from the current document
      Map<String, dynamic> userData = userDoc.data();

      // Check if the document contains 'canteenName' field
      if (userData.containsKey('canteenName')) {
        // Get the canteen name from the current document
        String? canteenDocName = userData['canteenName'] as String?;

        // If the canteen name matches the provided canteenName, return the owner's email
        if (canteenDocName == canteenName) {
          return userDoc.id;
        }
      }
    }
  } catch (e) {
    print("Error retrieving canteen owner's email: $e");
  }

  // Return null if canteen owner's email is not found
  return null;
}
double calculateTotalPrice(List<Map<String, dynamic>> order) {
    double totalPrice = 0.0;
    for (var item in order) {
      totalPrice += item['price']  * item['count'];
    }
    return totalPrice;
  }

  double calculateParcelCost(List<Map<String, dynamic>> order) {
    double parcelCost = 0.0;
    for (var item in order) {
      parcelCost += item['packageprice'] * item['count'];
    }
    return parcelCost;
  }
Future<Map<String, String>?> getUserDetailsFromEmail(String? userEmail) async {
  if (userEmail == null) return null;

  try {
    // Reference to the document with the provided email
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('LunchX') // Collection 'LunchX'
            .doc('customers') // Document 'customers' inside 'LunchX'
            .collection('users') // Collection 'users' inside 'customers'
            .doc(userEmail) // Document with provided userEmail as its ID
            .get();

    // If document exists, return the 'name' and 'phoneNumber' fields
    if (documentSnapshot.exists) {
      String? name = documentSnapshot.get('name') as String?;
      String? phoneNumber = documentSnapshot.get('phoneNumber') as String?;
      
      // Return a map containing both name and phoneNumber
      return {'name': name ?? '', 'phoneNumber': phoneNumber ?? ''};
    }
  } catch (e) {
    print("Error retrieving user details: $e");
  }

  // Return null if user's details are not found
  return null;
}
Future<int> getLatestOrderNumber() async {
    int latestOrderNumber = 0;

    try {
      // Retrieve the latest order number from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('canteen_orders_queue')
          .orderBy('orderNumber', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        latestOrderNumber = querySnapshot.docs.first['orderNumber'] as int;
      }
    } catch (e) {
      print("Error getting latest order number: $e");
    }

    return latestOrderNumber;
  }

void confirmOrder(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user);
    String? userEmail = user?.email;
    print('email: ${userEmail}');
   
    if (userEmail != null) {
      Map<String, String>? userDetails = await getUserDetailsFromEmail(userEmail);

      if (userDetails != null) {
        try {
          // Get the latest order number from Firestore
          int latestOrderNumber = await getLatestOrderNumber();
          print('$latestOrderNumber is the latest order number.');

          // Increment the order number for the new order
          int orderNumber = latestOrderNumber + 1;
          print('$orderNumber is the new order number.');

          // Map to store cart items
          List<Map<String, dynamic>> cartItemsList = [];

          // Add each item from the cart to the cartItemsList
          for (int i = 0; i < order.length; i++) {
            cartItemsList.add({
              'canteen': order[i]['canteen'],
              'count': order[i]['count'],
              'name': order[i]['name'],
              'price': order[i]['price'],
            });
          }
          DateTime now = DateTime.now();
String formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
          double totalOrderAmount =
          calculateTotalPrice(order) + calculateParcelCost(order);

          // Set the order details
          Map<String, dynamic> orderDetails = {
            'orderNumber': orderNumber,
            'userName': userDetails['name'],
             'phoneNumber': userDetails['phoneNumber'], // Adding phoneNumber
            'cartItems': cartItemsList,
            'totalPrice': totalOrderAmount,
            'accept?': 'pending',
            'cooking': true,
            'dispatch': false,
            'ready': false,
            'email': userEmail,
            'orderTime': formattedDateTime,
          };

          // Store order details in the "canteen_orders_queue" collection in Firestore
          CollectionReference canteenOrdersRef = FirebaseFirestore.instance
              .collection('LunchX')
              .doc('customers')
              .collection('canteen_orders_queue');

          // Store order details in the "canteen_orders_queue" collection
          await canteenOrdersRef.doc('Order #$orderNumber').set(orderDetails);

          // Store order details in the "current_order" collection in Firestore for the user
          CollectionReference currentUserOrdersRef = FirebaseFirestore.instance
              .collection('LunchX')
              .doc('customers')
              .collection('users')
              .doc(userEmail)
              .collection('current_orders');

// Store order details in the "current_order" collection
          await currentUserOrdersRef
              .doc('Order #$orderNumber')
              .set(orderDetails);

          // Send order details to canteen owner's folder based on canteen name
          for (var cartItem in cartItemsList) {
            print('canteen name is ${cartItem['canteen']}');
            String? canteenOwnerEmail =
                await getCanteenOwnerEmail(cartItem['canteen']);

            print('canteen owner email $canteenOwnerEmail');

            if (canteenOwnerEmail != null) {
              try {
                CollectionReference canteenOwnerOrdersRef = FirebaseFirestore
                    .instance
                    .collection('LunchX')
                    .doc('canteens')
                    .collection('users')
                    .doc(canteenOwnerEmail)
                    .collection('present_orders');

                // Store order details in canteen owner's folder
                await canteenOwnerOrdersRef
                    .doc('Order #$orderNumber')
                    .set(orderDetails);
              } catch (e) {
                print(
                    "Error storing order details in canteen owner's folder: $e");
              }
            }
          }
          // Clear the cart collection after moving items to "Current Orders"
          await FirebaseFirestore.instance
              .collection('LunchX')
              .doc('customers')
              .collection('users')
              .doc(userEmail)
              .collection('cart')
              .get()
              .then((querySnapshot) {
            for (QueryDocumentSnapshot doc in querySnapshot.docs) {
              doc.reference.delete();
            }
          });

        } catch (e) {
          // Handle any errors that occur
          print("Error confirming order: $e");
        }
      } else {
        print("Error: User name not found for email: $userEmail");
      }
    }
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
              Color(0xFF6CB65A), // Green
              Color(0xFF6CB65A), // Greens
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
                'Payment Successful',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(height: 20), // Add space between text and image
              Image.asset(
                'assets/clocky.gif',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20), // Add space between image and text
              Text(
                'Your order has been successfully placed!',
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