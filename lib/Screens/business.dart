import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../DataBase/database.dart';
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
    _loadBusinessData();
  }

  Future<void> _saveBusinessData() async {
    final businessData = {
      'name': bName.text,
      'email': bEmail.text,
      'phone': bPhone.text,
      'address': bAddress.text,
      'description': bDescription.text,
    };

    if (isEdit) {
      await DBHelper.instance.updateBusiness({
        ...businessData,
        'id': 1, // Assuming only one business record for simplicity
      });
    } else {
      await DBHelper.instance.insertBusiness(businessData);
    }

    setState(() {
      isEdit = false;
    });
  }

  Future<void> _loadBusinessData() async {
    final businesses = await DBHelper.instance.fetchBusinesses();

    if (businesses.isNotEmpty) {
      final business = businesses.first;
      setState(() {
        bName.text = business['name'] ?? '';
        bEmail.text = business['email'] ?? '';
        bPhone.text = business['phone'] ?? '';
        bAddress.text = business['address'] ?? '';
        bDescription.text = business['description'] ?? '';
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

  void _discardChanges() {
    setState(() {
      isEdit = false;
    });
    _loadBusinessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),
      appBar: AppBar(
        title: const Text("Business Profile"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: isEdit
            ? [
          IconButton(
            onPressed: _saveBusinessData,
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
                    fontWeight: FontWeight.bold),
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
                        onPressed: isEdit ? _pickImage : null,
                        icon: const Icon(CupertinoIcons.camera,
                            size: 44, color: Colors.white),
                      ),
                    ),
                  )
                      : Image.file(File(_imagePath!)),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Name", "Enter Business name", bName,
                  isEnabled: isEdit),
              _buildTextField("Email", "Enter Business email", bEmail,
                  isEnabled: isEdit),
              _buildTextField("Phone", "Enter phone number", bPhone,
                  keyboardType: TextInputType.phone, isEnabled: isEdit),
              _buildTextField("Address", "Enter Business address", bAddress,
                  isEnabled: isEdit),
              _buildTextField("Description", "Enter Business description",
                  bDescription,
                  maxLines: 3, isEnabled: isEdit),
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
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: isEnabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15),
          hintText: value,
          hintStyle: const TextStyle(color: Colors.blue, fontSize: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black),
          ),
          filled: true,
        ),
        style: TextStyle(
          color: isEnabled ? Colors.black : Colors.black87,
        ),
      ),
    );
  }
}