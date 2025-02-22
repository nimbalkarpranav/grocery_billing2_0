import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/DataBase/database.dart';
import 'package:grocery_billing2_0/drawer/drawer.dart';
import 'customerlist.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _addCustomer() async {
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      Map<String, dynamic> newCustomer = {
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
      };

      await DBHelper.instance.insertCustomer(newCustomer);

      _showSnackbar("Customer added successfully!", Colors.green);

      // Clear inputs
      nameController.clear();
      phoneController.clear();
      emailController.clear();

      // Navigate back to customer list
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomersPage()),
      );
    } else {
      _showSnackbar("Please fill in all fields", Colors.orange);
    }
  }

  void _deleteCustomer(int customerId) async {
    bool confirmDelete = await _showDeleteConfirmation();
    if (confirmDelete) {
      await DBHelper.instance.deleteCustomer(customerId);
      _showSnackbar("Customer deleted successfully!", Colors.red);
      setState(() {}); // Refresh UI
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this customer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel", style: TextStyle(color: Colors.blueAccent)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.blueAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Add New Customer",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // Dummy ID, replace it with selected customer ID
              _deleteCustomer(1);
            },
          ),
        ],
      ),
      drawer: const drawerPage(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(nameController, "Customer Name", Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField(phoneController, "Phone", Icons.phone,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildTextField(emailController, "Email", Icons.email,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addCustomer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Add Customer",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.blueAccent.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }
}
