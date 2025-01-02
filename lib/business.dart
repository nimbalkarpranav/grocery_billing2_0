import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/business_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer/drawer.dart';

class Business extends StatefulWidget {
  const Business({super.key});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  String? _imagePath;
  String? _name;
  String? _email;
  String? _phone;
  String? _address;
  String? _description;

  @override
  void initState() {
    super.initState();
    _loadBusinessData();
  }

  Future<void> _loadBusinessData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('business_image');
      _name = prefs.getString('business_name') ?? "N/A";
      _email = prefs.getString('business_email') ?? "N/A";
      _phone = prefs.getString('business_phone') ?? "N/A";
      _address = prefs.getString('business_address') ?? "N/A";
      _description = prefs.getString('business_description') ?? "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),
      appBar: AppBar(
        title: const Text("Business Profile"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessEdit(),));
          }, icon: Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Business Information",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _imagePath != null
                  ? Image.file(
                File(_imagePath!),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
                  : const Icon(
                Icons.business,
                size: 150,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              _buildInfoRow("Name", _name),
              _buildInfoRow("Email", _email),
              _buildInfoRow("Phone", _phone),
              _buildInfoRow("Address", _address),
              _buildInfoRow("Description", _description),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? "N/A",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
