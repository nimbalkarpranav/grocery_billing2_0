import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessEdit extends StatefulWidget {
  const BusinessEdit({super.key});

  @override
  State<BusinessEdit> createState() => _BusinessEditState();
}

class _BusinessEditState extends State<BusinessEdit> {
  String? _imagePath;
  TextEditingController bName = TextEditingController();
  TextEditingController bEmail = TextEditingController();
  TextEditingController bPhone = TextEditingController();
  TextEditingController bAddress = TextEditingController();
  TextEditingController bDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('BusinessEdit_image');
      bName.text = prefs.getString('BusinessEdit_name') ?? '';
      bEmail.text = prefs.getString('BusinessEdit_email') ?? '';
      bPhone.text = prefs.getString('BusinessEdit_phone') ?? '';
      bAddress.text = prefs.getString('BusinessEdit_address') ?? '';
      bDescription.text = prefs.getString('BusinessEdit_description') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('BusinessEdit_image', _imagePath ?? '');
    await prefs.setString('BusinessEdit_name', bName.text);
    await prefs.setString('BusinessEdit_email', bEmail.text);
    await prefs.setString('BusinessEdit_phone', bPhone.text);
    await prefs.setString('BusinessEdit_address', bAddress.text);
    await prefs.setString('BusinessEdit_description', bDescription.text);
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
      _saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BusinessEdit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "BusinessEdit Image",
                style: TextStyle(fontSize: 21, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Container(
                  height: 140,
                  width: 300,
                  color: Colors.black,
                  child: _imagePath == null
                      ? Padding(
                    padding: const EdgeInsets.all(33.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      maxRadius: 33,
                      child: IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(CupertinoIcons.camera, size: 44, color: Colors.white),
                      ),
                    ),
                  )
                      : Image.file(File(_imagePath!)),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Name", "Enter BusinessEdit name", bName),
              _buildTextField("Email", "Enter BusinessEdit email", bEmail),
              _buildTextField("Phone", "Enter phone number", bPhone, keyboardType: TextInputType.phone),
              _buildTextField("Address", "Enter BusinessEdit address", bAddress),
              _buildTextField("Description", "Enter BusinessEdit description", bDescription, maxLines: 3),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveData,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: (value) => _saveData(),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}
