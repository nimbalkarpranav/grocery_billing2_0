import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadSavedData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Person_Img', _imagePath ?? '');
    await prefs.setString('Person_name', pName.text);
    await prefs.setString('Person_Email', pEmail.text);
    await prefs.setString('Person_phone', pPhone.text);
    await prefs.setString('Person_Address', pAddress.text);
    await prefs.setString('Person_Pin', pPin.text);
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('Person_Img');
      pName.text = prefs.getString('Person_name') ?? '';
      pEmail.text = prefs.getString('Person_Email') ?? '';
      pPhone.text = prefs.getString('Person_phone') ?? '';
      pAddress.text = prefs.getString('Person_Address') ?? '';
      pPin.text = prefs.getString('Person_Pin') ?? '';
    });
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
      if (isEdit) _saveData();
    }
  }

  void _enableEdit() {
    setState(() {
      isEdit = true;
    });
  }

  void _saveChanges() {
    setState(() {
      isEdit = false;
    });
    _saveData();
  }

  void _discardChanges() {
    setState(() {
      isEdit = false;
    });
    _loadSavedData();
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
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: isEdit ? _pickImage : null,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.blueAccent,
                    backgroundImage: _imagePath != null &&
                        File(_imagePath!).existsSync()
                        ? FileImage(File(_imagePath!))
                        : const AssetImage('assetsimage/propic.jpeg')
                    as ImageProvider,
                  ),
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
              _buildTextField("New Pin", "Enter pin code", pPin,
                  maxLines: 1, isEnabled: isEdit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String value,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
        required bool isEnabled,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        style:  TextStyle(
      color: isEnabled ? Colors.black : Colors.black87,
      ),
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: isEnabled,
        decoration: InputDecoration(

          labelText: label,
          hintText: value,
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
