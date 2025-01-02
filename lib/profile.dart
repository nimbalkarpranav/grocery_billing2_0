import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = "Person Name";
  String email = "example@email.com";
  String phone = "1234567890";
  String address = "Default Address";

  // Controllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "Person Name";
      email = prefs.getString('email') ?? "example@email.com";
      phone = prefs.getString('phone') ?? "1234567890";
      address = prefs.getString('address') ?? "Default Address";
    });
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
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
              const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                maxRadius: 30,
                backgroundImage: AssetImage('assetsimage/propic.jpeg'),
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
          labelStyle: const TextStyle(color:Colors.black87 ,fontWeight: FontWeight.bold),
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
          fillColor: isEnabled ? Colors.blue.shade100 : Colors.blue.shade50,
        ),
        style: TextStyle(
          color: isEnabled ? Colors.black : Colors.grey.shade700,
        ),
      ),
    );
  }
}
