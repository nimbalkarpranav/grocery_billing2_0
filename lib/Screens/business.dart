import 'dart:io';
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
    checkBusinessData();
  }
  Future<void> checkBusinessData() async {
    final businesses = await DBHelper.instance.fetchBusinesses();
    print("Stored Businesses: $businesses");
  }

  Future<void> _saveBusinessData() async {
    final businesses = await DBHelper.instance.fetchBusinesses();
    bool hasBusiness = businesses.isNotEmpty; // Check if data exists

    final businessData = {
      'id': hasBusiness ? businesses.first['id'] : null, // Agar data hai toh use karo
      'name': bName.text,
      'email': bEmail.text,
      'phone': bPhone.text,
      'address': bAddress.text,
      'description': bDescription.text,
      'imagePath': _imagePath,
    };

    if (hasBusiness) {
      await DBHelper.instance.updateBusiness(businessData);
    } else {
      await DBHelper.instance.insertBusiness(businessData);
    }

    _loadBusinessData(); // Refresh the UI
    setState(() => isEdit = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Business Profile Saved Successfully!")),
    );
  }



  Future<void> _loadBusinessData() async {
    final businesses = await DBHelper.instance.fetchBusinesses();
    print("Business List: $businesses"); // Debugging ke liye print kar de
    if (businesses.isNotEmpty) {
      final business = businesses.first;
      setState(() {
        bName.text = business['name'] ?? '';
        bEmail.text = business['email'] ?? '';
        bPhone.text = business['phone'] ?? '';
        bAddress.text = business['address'] ?? '';
        bDescription.text = business['description'] ?? '';
        _imagePath = business['imagePath'];
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

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 6, spreadRadius: 2),
        // ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: isEnabled,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
