import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchx_order/Canteen/canteenlogin.dart';
import 'package:lunchx_order/Customer/login.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: 
      Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/left.png', // Replace with your left image asset
              width: MediaQuery.of(context).size.width / 3,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/right.png', // Replace with your right image asset
              width: MediaQuery.of(context).size.width / 3,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/white.png', // Replace with your LunchX logo asset
                    width: MediaQuery.of(context).size.width / 6, // Adjust the width as needed
                    // height: MediaQuery.of(context).size.width / 6, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20), // Adjust vertical spacing as needed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Preorder',
                        style: GoogleFonts.outfit(
                          fontSize: 24.0,
                          color: const Color(0xff6552FE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' Food,',
                        style: GoogleFonts.outfit(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'at no',
                        style: GoogleFonts.outfit(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ' hustle',
                        style: GoogleFonts.outfit(
                          fontSize: 24.0,
                          color: const Color(0xff6552FE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                   Image.asset(
                    'assets/clock_purple.jpeg', // Replace with your LunchX logo asset
                    width: MediaQuery.of(context).size.width /2 - 20, // Adjust the width as needed
                    // height: MediaQuery.of(context).size.width / 6, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                   const SizedBox(height: 20,),
                  Text(
                        'Stay Free  From  Long Queues',
                        style: GoogleFonts.outfit(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 25,),
ElevatedButton(
  onPressed: () {
   Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  },

  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6552FE), // Background color

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50), // Adjust padding as needed
  ),
  child: Text(
    'Get Started',
    style: GoogleFonts.outfit(
      fontSize: 14,
      color: Colors.white, // Text color
      fontWeight: FontWeight.w500,
    ),
  ),
),
const SizedBox(height: 25,),
                 InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CanteenLogin()),
    );
  },
  child: Text(
    'Canteen ?',
    style: GoogleFonts.outfit(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
  ),
),
const SizedBox(height: 30,),
                 Image.asset(
                  'assets/art.png', // Replace with your LunchX logo asset
                  width: MediaQuery.of(context).size.width, // Adjust the width as needed
                  // height: MediaQuery.of(context).size.width / 6, // Adjust the height as needed
                  fit: BoxFit.fitWidth,
                ),

                ],
              ),
            ),
          ),
             
        ],
      ),
    );
  }
}