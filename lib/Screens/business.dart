import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      'id': 1,
      'name': bName.text,
      'email': bEmail.text,
      'phone': bPhone.text,
      'address': bAddress.text,
      'description': bDescription.text,
      'image': _imagePath,
    };

    if (isEdit) {
      await DBHelper.instance.updateBusiness(businessData);
    } else {
      await DBHelper.instance.insertBusiness(businessData);
    }

    setState(() => isEdit = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Business Profile Saved Successfully!")),
    );
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
        _imagePath = business['image'];
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
      setState(() => _imagePath = newPath);
    }
  }

  void _enableEdit() => setState(() => isEdit = true);

  void _discardChanges() {
    setState(() => isEdit = false);
    _loadBusinessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),
      appBar: AppBar(
        title: const Text("Business Profile"),
        centerTitle: true,
        actions: isEdit
            ? [
          IconButton(onPressed: _saveBusinessData, icon: const Icon(Icons.save)),
          IconButton(onPressed: _discardChanges, icon: const Icon(Icons.cancel)),
        ]
            : [
          IconButton(onPressed: _enableEdit, icon: const Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: isEdit ? _pickImage : null,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                child: _imagePath == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField("Business Name", bName, isEdit),
            _buildTextField("Email", bEmail, isEdit),
            _buildTextField("Phone", bPhone, isEdit, keyboardType: TextInputType.phone),
            _buildTextField("Address", bAddress, isEdit),
            _buildTextField("Description", bDescription, isEdit, maxLines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isEnabled,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: isEnabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
