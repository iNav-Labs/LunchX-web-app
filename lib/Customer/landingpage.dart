import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchx_order/Canteen/canteenlogin.dart';
import 'package:lunchx_order/Customer/login.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  final String _privacyPolicyUrl =
      'https://www.termsfeed.com/live/43d036d6-de13-4777-a476-77aeb35d6ee3';
  final String _termsConditionsUrl = 'https://www.termsfeed.com/live/4e458585-425a-4b42-9d88-8e4c646fb40d';
  final String _contactUsUrl = 'https://lunchx.web.app';
  final String _cancellationRefundUrl =
      'https://www.privacypolicies.com/live/b02cac83-5029-4469-bec7-af496322acb7';

  Future<void> _launchUrl(String url) async {
    if (!await launch(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallDevice = screenWidth < 400;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/left.png',
              width: isSmallDevice ? screenWidth / 3 : screenWidth / 5,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/right.png',
              width: isSmallDevice ? screenWidth / 3 : screenWidth / 5,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/white.png',
                    width: isSmallDevice ? screenWidth / 4 : screenWidth / 8,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Preorder',
                        style: GoogleFonts.outfit(
                          fontSize: isSmallDevice ? 18.0 : 24.0,
                          color: const Color(0xff6552FE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' Food,',
                        style: GoogleFonts.outfit(
                          fontSize: isSmallDevice ? 18.0 : 24.0,
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
                          fontSize: isSmallDevice ? 18.0 : 24.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ' hustle',
                        style: GoogleFonts.outfit(
                          fontSize: isSmallDevice ? 18.0 : 24.0,
                          color: const Color(0xff6552FE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/clock_purple.jpeg',
                    width: isSmallDevice ? screenWidth / 2 - 20 : screenWidth / 3 - 20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Stay Free From Long Queues',
                    style: GoogleFonts.outfit(
                      fontSize: isSmallDevice ? 14.0 : 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6552FE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isSmallDevice ? 20 : 30),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallDevice ? 8 : 12,
                        horizontal: isSmallDevice ? 20 : 50,
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: GoogleFonts.outfit(
                        fontSize: isSmallDevice ? 10 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
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
                        fontSize: isSmallDevice ? 10.0 : 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _launchUrl(_privacyPolicyUrl);
                        },
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(color: Colors.grey, fontSize: 8),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchUrl(_termsConditionsUrl);
                        },
                        child: const Text(
                          'Terms and Conditions',
                          style: TextStyle(color: Colors.grey, fontSize: 8),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchUrl(_contactUsUrl);
                        },
                        child: const Text(
                          'Contact Us',
                           style: TextStyle(color: Colors.grey, fontSize: 8),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchUrl(_cancellationRefundUrl);
                        },
                        child: const Text(
                          'Cancellation Refund',
                          style: TextStyle(color: Colors.grey, fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/art.png',
                    width: screenWidth,
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
