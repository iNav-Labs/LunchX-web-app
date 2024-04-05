import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunchx_order/Canteen/canteen_dashboard.dart';

class CanteenRegistration extends StatefulWidget {
  const CanteenRegistration({Key? key}) : super(key: key);

  @override
  _CanteenRegistrationState createState() => _CanteenRegistrationState();
}

class _CanteenRegistrationState extends State<CanteenRegistration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _canteenNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Widget _buildImageWidget() {
    if (_imageBytes != null) {
      return Image.memory(
        _imageBytes!, // Use _imageBytes instead of File
        fit: BoxFit.cover,
        height: 150.0,
        width: double.infinity,
      );
    } else {
      return const Center(
        child: Icon(Icons.camera_alt, size: 50.0),
      );
    }
  }

  bool _validateFields() {
    return _imageBytes != null &&
        _nameController.text.isNotEmpty &&
        _canteenNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
  }

  void _showAlertDialog(bool saved) {
    String message = saved
        ? 'Canteen registration is saved!'
        : 'Please fill all fields and upload an image.';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(saved ? 'Success' : 'Alert'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (saved) {
                _registerCanteen();
                // Navigate to dashboard screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardCanteen(),
                  ),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _registerCanteen() async {
    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        print('Starting canteen registration process...');

        // Upload image to Firebase Storage
        Reference storageRef = FirebaseStorage.instance.ref('canteen_image/${_nameController.text}');
        SettableMetadata metadata = SettableMetadata(
          contentType: 'image/jpeg', // Set the content type of the image
        );

        print('Uploading image to Firebase Storage...');
        await storageRef.putData(_imageBytes!, metadata);
        print('Image uploaded successfully!');

        // Get download URL for the uploaded image
        print('Getting download URL for the uploaded image...');
        String imageUrl = await storageRef.getDownloadURL();
        print('Download URL obtained: $imageUrl');

        print('Adding canteen details to Firestore...');
        await FirebaseFirestore.instance
            .collection('LunchX')
            .doc('canteens')
            .collection('users')
            .doc(userEmail)
            .set({
          'name': _nameController.text,
          'canteenName': _canteenNameController.text,
          'phoneNumber': _phoneController.text,
          'imagePath': imageUrl,
        });

        print('Canteen registration completed successfully!');

        setState(() {
          _imageBytes = null;
          _nameController.clear();
          _canteenNameController.clear();
          _phoneController.clear();
        });

        _showAlertDialog(true);
      }
    } catch (e) {
      print('Error occurred during canteen registration: $e');
      _showAlertDialog(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canteen Registration'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                'Upload Canteen Image:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _buildImageWidget(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _canteenNameController,
                decoration: const InputDecoration(
                  labelText: 'Canteen Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  if (_validateFields()) {
                    _registerCanteen();
                  } else {
                    _showAlertDialog(false);
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
