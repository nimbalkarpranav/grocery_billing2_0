import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DataBase/database.dart';
import '../drawer/drawer.dart';
import 'PinScreen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isEdit = false;
  String? _imagePath;
  final TextEditingController pName = TextEditingController();
  final TextEditingController pEmail = TextEditingController();
  final TextEditingController pPhone = TextEditingController();
  final TextEditingController pAddress = TextEditingController();
  final TextEditingController pPin = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
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

  Future<void> _saveProfile() async {
    final existingProfile = await DBHelper.instance.fetchProfile();
    if (existingProfile == null) return;

    bool isPinChanged = pPin.text != existingProfile['pin']; // 🔹 Check if PIN is changed

    final profile = {
      'name': pName.text,
      'email': pEmail.text,
      'phone': pPhone.text,
      'address': pAddress.text,
      'pin': pPin.text,
    };

    await DBHelper.instance.updateProfile({...profile, 'id': existingProfile['id']});

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPIN', pPin.text);
    await prefs.setBool('isProfileCompleted', true);

    _showSnackbar("Profile updated successfully!");

    setState(() => isEdit = false);

    // ✅ PinScreen pe sirf tabhi bhejo jab PIN change ho
    if (isPinChanged) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PinScreen()),
          );
        }
      });
    }
  }



  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/${pickedFile.name}';
      await File(pickedFile.path).copy(newPath);

      setState(() => _imagePath = newPath);

      final existingProfile = await DBHelper.instance.fetchProfile();
      if (existingProfile != null) {
        await DBHelper.instance.updateProfile({'id': existingProfile['id'], 'imagePath': newPath});
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: isEdit,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(isEdit ? Icons.save : Icons.edit,),color: Colors.white,
            onPressed: isEdit ? _saveProfile : () => setState(() => isEdit = true),
          ),
          if (isEdit)
            IconButton(
              icon: Icon(Icons.cancel),color: Colors.white,
              onPressed: () => setState(() => isEdit = false),
            ),
        ],
      ),
      body: Container(
        color: Colors.blue[50], // 🔹 Fix: Background color change to match entire screen
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: isEdit ? _pickImage : null,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _imagePath != null && File(_imagePath!).existsSync()
                          ? FileImage(File(_imagePath!))
                          : AssetImage('assetsimage/propic.jpeg') as ImageProvider,
                    ),
                    if (isEdit)
                      Container(
                        decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.camera_alt, color: Colors.white70, size: 24),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Name", pName),
              _buildTextField("Email", pEmail),
              _buildTextField("Phone", pPhone, keyboardType: TextInputType.phone),
              _buildTextField("Address", pAddress),
              _buildTextField("PIN", pPin, keyboardType: TextInputType.number),
              SizedBox(height: 20),
              if (isEdit)
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // 🔹 Fix: Button color now matches theme
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  ),
                  child: Text("SAVE ", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
            ],
          ),
        ),
      ),

    );
  }
}
