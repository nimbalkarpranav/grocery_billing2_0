import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../drawer/drawer.dart';

class BusinessEdit extends StatefulWidget {
  const BusinessEdit({super.key});

  @override
  State<BusinessEdit> createState() => _BusinessEditState();
}

class _BusinessEditState extends State<BusinessEdit> {
  bool isEdit = false;
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
      if (isEdit) _saveData();
    } else {
      // Feedback if no image is selected
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected")),
        );
      }
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
      drawer: drawerPage(),
      appBar: AppBar(
        title: const Text(
          "Business Profile",
          style: TextStyle(color: Colors.white),
        ),
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
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Business Image",
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                        image: _imagePath != null
                            ? DecorationImage(
                          image: FileImage(File(_imagePath!)),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: _imagePath == null
                          ? IconButton(
                        onPressed: isEdit ? _pickImage : null,
                        icon: const Icon(
                          CupertinoIcons.camera,
                          size: 44,
                          color: Colors.black,
                        ),
                      )
                          : null,
                    ),
                    if (isEdit && _imagePath != null)
                      Positioned(
                        bottom: -8,
                        right: -8,
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: const Icon(
                            CupertinoIcons.camera_fill,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildCardField("Name", "Enter Business name", bName),
              _buildCardField("Email", "Enter Business email", bEmail),
              _buildCardField(
                "Phone",
                "Enter phone number",
                bPhone,
                keyboardType: TextInputType.phone,
              ),
              _buildCardField("Address", "Enter Business address", bAddress),
              _buildCardField(
                "Description",
                "Enter Business description",
                bDescription,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardField(
      String label,
      String hint,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            TextField(
              controller: controller,style: TextStyle(color: Colors.black87),

              keyboardType: keyboardType,
              maxLines: maxLines,
              enabled: isEdit,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
