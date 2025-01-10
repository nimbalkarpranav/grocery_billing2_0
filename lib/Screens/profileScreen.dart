import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../DataBase/database.dart';
import 'PinScreen.dart'; // Your PIN screen

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isEdit = false;
  String? _imagePath;
  TextEditingController pName = TextEditingController();
  TextEditingController pEmail = TextEditingController();
  TextEditingController pPhone = TextEditingController();
  TextEditingController pAddress = TextEditingController();
  TextEditingController pPin = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileFromDB();
  }

  Future<void> _loadProfileFromDB() async {
    final profile = await DBHelper.instance.fetchProfile();
    if (profile != null) {
      setState(() {
        pName.text = profile['name'];
        pEmail.text = profile['email'];
        pPhone.text = profile['phone'];
        pAddress.text = profile['address'];
        pPin.text = profile['pin'];
        _imagePath = profile['imagePath'];
      });
    }
  }

  Future<void> _saveProfileToDB() async {
    final profile = {
      'name': pName.text,
      'email': pEmail.text,
      'phone': pPhone.text,
      'address': pAddress.text,
      'pin': pPin.text,
      'imagePath': _imagePath,
    };

    final existingProfile = await DBHelper.instance.fetchProfile();
    if (existingProfile == null) {
      await DBHelper.instance.insertProfile(profile);
    } else {
      await DBHelper.instance.updateProfile({
        ...profile,
        'id': existingProfile['id'],
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String newPath = '${directory.path}/${pickedFile.name}';
      final File file = File(pickedFile.path);
      await file.copy(newPath);

      setState(() {
        _imagePath = newPath;
      });
    }
  }

  void _enableEdit() {
    setState(() {
      isEdit = true;
    });
  }

  void _saveChanges() async {
    // Debugging to ensure save action happens
    print("Saving changes...");
    await _saveProfileToDB();
    setState(() {
      isEdit = false;
    });

    // Debugging PIN change
    if (pPin.text.isNotEmpty) {
      print("New PIN: ${pPin.text}");

      // If PIN has been changed, navigate to the PIN screen with the updated PIN
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinScreen(savedPin: pPin.text), // Pass updated PIN
        ),
      );
    } else {
      print("No PIN updated, staying on the profile page.");
    }
  }

  void _discardChanges() {
    setState(() {
      isEdit = false;
    });
    _loadProfileFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: isEdit
            ? [
          IconButton(
            onPressed: _saveChanges,
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: _discardChanges,
            icon: const Icon(Icons.cancel),
          ),
        ]
            : [
          IconButton(
            onPressed: _enableEdit,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blueAccent,
                      backgroundImage: _imagePath != null &&
                          File(_imagePath!).existsSync()
                          ? FileImage(File(_imagePath!))
                          : const AssetImage('assetsimage/propic.jpeg')
                      as ImageProvider,
                    ),
                    if (isEdit)
                      Positioned(
                        bottom: 10,
                        right: 16,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  "Name", "Enter your name", pName, isEnabled: isEdit),
              _buildTextField(
                  "Email", "Enter your email", pEmail, isEnabled: isEdit),
              _buildTextField("Phone", "Enter phone number", pPhone,
                  keyboardType: TextInputType.phone, isEnabled: isEdit),
              _buildTextField("Address", "Enter your address", pAddress,
                  isEnabled: isEdit),
              _buildTextField("Change pin", "Enter your PIN", pPin,
                  keyboardType: TextInputType.number, isEnabled: isEdit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
        required bool isEnabled}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: isEnabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
