import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'drawer/drawer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = "";
  String email = "";
  String phone = "";
  String address = "";
  String profileImagePath = "";

  // Controllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool isEdit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  Future<void> _saveUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', userName);
      print(userName);
      await prefs.setString('email', email);
      await prefs.setString('phone', phone);
      await prefs.setString('address', address);
      await prefs.setString('profileImagePath', profileImagePath);
      debugPrint("Data saved successfully");
    } catch (e) {
      debugPrint("Error saving data: $e");
    }
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userName = prefs.getString('userName') ?? "";
        email = prefs.getString('email') ?? "";
        phone = prefs.getString('phone') ?? "";
        address = prefs.getString('address') ?? "";
        profileImagePath = prefs.getString('profileImagePath') ?? "";
      });
      debugPrint("Data loaded successfully");
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  void _enableEdit() {
    setState(() {
      isEdit = true;
      _nameController.text = userName;
      _emailController.text = email;
      _phoneController.text = phone;
      _addressController.text = address;
    });
  }

  void _saveChanges() {
    setState(() {
      userName = _nameController.text.trim();
      email = _emailController.text.trim();
      phone = _phoneController.text.trim();
      address = _addressController.text.trim();
      isEdit = false;
    });
    _saveUserData();
  }

  void _discardChanges() {
    setState(() {
      isEdit = false;
    });
  }

  Future<void> _changeImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImagePath = pickedFile.path;
      });
      _saveUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),
      appBar: AppBar(
        title: const Text("Profile Page"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _changeImage,
                child: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  maxRadius: 50,
                  backgroundImage: profileImagePath.isNotEmpty
                      ? FileImage(File(profileImagePath))
                      : const AssetImage('assetsimage/propic.jpeg')
                  as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                "Name",
                userName,
                _nameController,
                isEnabled: isEdit,
              ),
              _buildTextField(
                "Email",
                email,
                _emailController,
                keyboardType: TextInputType.emailAddress,
                isEnabled: isEdit,
              ),
              _buildTextField(
                "Phone",
                phone,
                _phoneController,
                keyboardType: TextInputType.phone,
                isEnabled: isEdit,
              ),
              _buildTextField(
                "Address",
                address,
                _addressController,
                maxLines: 2,
                isEnabled: isEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, TextEditingController controller,
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
          labelStyle: const TextStyle(
              color: Colors.blueAccent, fontWeight: FontWeight.bold,fontSize: 20),
          hintText: value,
          hintStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          filled: true,
          // fillColor: isEnabled ? Colors.blue.shade100 : Colors.blue.shade50,
        ),
        style: TextStyle(
          color: isEnabled ? Colors.black : Colors.black87,
        ),
      ),
    );
  }
}
