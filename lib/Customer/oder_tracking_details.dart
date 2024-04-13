// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunchx_order/Customer/refund_page.dart';

class OrderDetailsCard extends StatelessWidget {
  final double cardWidth;
  final int time = 10;

  const OrderDetailsCard({super.key, required this.cardWidth});

  Future<List<Map<String, dynamic>>> fetchOrderDetails() async {
    List<Map<String, dynamic>> orders = [];

    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Initialize Firestore reference properly
      CollectionReference currentUserOrdersRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('users')
          .doc(user!.email)
          .collection('current_orders');

      // Fetch documents from Firestore
      QuerySnapshot querySnapshot = await currentUserOrdersRef.get();
      orders = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (error) {
      print('Error fetching orders: $error');
    }

    return orders;
  }

  Future<void> refundOrder(String? userEmail, int? orderNumber) async {
    if (userEmail != null && orderNumber != null) {
      final userRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('users')
          .doc(userEmail);

      // Reference to the order document in current_orders
      DocumentReference orderRef =
          userRef.collection('current_orders').doc('Order #$orderNumber');

      try {
        // Get the order data
        DocumentSnapshot orderSnapshot = await orderRef.get();

        if (orderSnapshot.exists) {
          // Store the order in OrderHistory
          await userRef
              .collection('OrderHistory')
              .doc('Order #$orderNumber')
              .set(orderSnapshot.data() as Map<String, dynamic>);

          // Delete the order from current_orders
          await orderRef.delete();
        } else {
          print('Order not found in current_orders.');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('User email or order number is null.');
    }
  }

  Widget buildOrderAcceptButton(
    BuildContext context,
      String acceptStatus, int orderNumber, String user_email) {
    return Visibility(
      visible: acceptStatus == 'reject',
      child: Center(
        child: SizedBox(
          height: 30, // Adjust the height as needed
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6552FE), // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 5, // Adjust the padding as needed
              ),
            ),
           onPressed: () {
              refundOrder(user_email, orderNumber).then((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RefundProcessingScreen(),
                  ),
                );
              }).catchError((error) {
                // Handle error if refund fails
                // print('Error processing refund: $error');
              });
            },
            child: Text(
              'Refund',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchOrderDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching data!'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No data available!'),
          );
        }

        final List<Map<String, dynamic>> orderData = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: orderData.map((order) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: SizedBox(
                  width: cardWidth - 30,
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Set border radius to 15
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
      color:  Colors.black, // Set border color to black
      width: 3.0, // Set border width to 2px
    ),
                        color: Colors
                            .white, // Set the background color to pure white
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 15.0), // Padding only from the left side
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align text to the left
                              children: [
                                Text(
                                  'Your Order',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Almost zero platform fees applied.',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF6552FE),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: cardWidth / 2 +
                                    10, // Half of the card's width
                                height: 35.0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Order Number',
                                      style: GoogleFonts.outfit(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: cardWidth / 3 - 20,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                  child: Text(
                                    '#${order['orderNumber']}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF6552FE),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0), // Add some spacing
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: cardWidth / 2 +
                                    10, // Half of the card's width
                                height: 35.0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Shop / Canteen',
                                      style: GoogleFonts.outfit(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: cardWidth / 3 - 10,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                  child: Text(
                                    '${order['cartItems'] != null && order['cartItems'].isNotEmpty ? order['cartItems'][0]['canteen'] ?? 'Unknown' : 'Unknown'}', // Assuming you want to display the canteen of the first item in cartItems
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                           const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: cardWidth / 2 +
                                    10, // Half of the card's width
                                height: 35.0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Date \nTime',
                                      style: GoogleFonts.outfit(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: cardWidth / 3 - 20,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                  child: Text(
                                    '${order['orderTime']}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      color:  Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0), // Add some spacing
                            ],
                          ),
                             const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: cardWidth / 2 +
                                    10, // Half of the card's width
                                height: 35.0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Order',
                                      style: GoogleFonts.outfit(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: cardWidth / 3 - 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children:
                                        order['cartItems'].map<Widget>((item) {
                                      return Text(
                                        '${item['name']}', // Display the name of each item in a new line
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.outfit(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: cardWidth / 10 - 25,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children:
                                        order['cartItems'].map<Widget>((item) {
                                      return Text(
                                        '${item['count']}', // Display the count of each item
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.outfit(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0), // Add some spacing
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: cardWidth / 2 +
                                    10, // Half of the card's width
                                height: 35.0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Order Request Status',
                                      style: GoogleFonts.outfit(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: cardWidth / 3 - 10,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        '${order['accept?']}',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.outfit(
                                          color: order['accept?'] == 'accept'
                                              ? Colors.green
                                              : order['accept?'] == 'pending'
                                                  ? Colors.blue
                                                  : Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10), // Adjust as needed
                          buildOrderAcceptButton(context,order['accept?'],
                              order['orderNumber'], order['email']),

                          const SizedBox(
                              height: 18), // Add spacing between sections
                          Center(
                            child: Container(
                              height: 180,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  
                                  Container(
                                    width: 140,
                                    height: 140,
                                    margin: const EdgeInsets.only(right: 7),
                                   
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: order['ready']
                                          ? Colors.green
                                          : const Color(0xFFF19D20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                           const SizedBox(height: 10),
                                        Text(
                                          'Order Status',
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Image.asset(
                                          'assets/pizza.gif', // Replace with the path to your logo image
                                          width:
                                              60, // Adjust the width as needed
                                          height:
                                              60, // Adjust the height as needed
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          order['ready'] ? 'Ready' : 'Cooking',
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 140,
                                    height: 140,
                                    margin: const EdgeInsets.only(left: 7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xFF6552FE),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                         const SizedBox(height: 10),
                                        Text(
                                          'Expected Time',
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Image.asset(
                                          'assets/alarm.gif', // Replace with the path to your logo image
                                          width:
                                              60, // Adjust the width as needed
                                          height:
                                              60, // Adjust the height as needed
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          order['cooking']
                                              ? "${order['ETP']} mins"
                                              : "0 mins",
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                         const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}