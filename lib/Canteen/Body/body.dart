// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:lunchx_order/Canteen/Body/vertical_orders.dart';

class BodySectionCanteen extends StatefulWidget {
  const BodySectionCanteen({super.key});

  @override
  State<BodySectionCanteen> createState() => _BodySectionCanteenState();
}

class _BodySectionCanteenState extends State<BodySectionCanteen> {
  late List<Map<String, dynamic>> orders;
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height, // Ensure the Column takes up the full height
              child: const VerticalOrders(),
            ),
          ],
        ),
      ),
    );
  }
}