import 'package:flutter/material.dart';
import '../DataBase/database.dart';
import '../drawer/drawer.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<Map<String, dynamic>> _customers = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int? _editingCustomerId;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    final data = await DBHelper.instance.fetchCustomers();
    setState(() {
      _customers = data;
    });
  }

  void _showCustomerDialog({int? customerId}) {
    if (customerId != null) {
      final customer = _customers.firstWhere((c) => c['id'] == customerId);
      _nameController.text = customer['name'];
      _phoneController.text = customer['phone'];
      _emailController.text = customer['email'] ?? '';
      _editingCustomerId = customerId;
    } else {
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _editingCustomerId = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(_editingCustomerId == null ? "Add Customer" : "Edit Customer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_nameController, "Customer Name", Icons.person),
              SizedBox(height: 10),
              _buildTextField(_phoneController, "Phone", Icons.phone, keyboardType: TextInputType.phone),
              SizedBox(height: 10),
              _buildTextField(_emailController, "Email", Icons.email, keyboardType: TextInputType.emailAddress),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () async {
                if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                  Map<String, dynamic> customerData = {
                    'name': _nameController.text,
                    'phone': _phoneController.text,
                    'email': _emailController.text,
                  };
                  if (_editingCustomerId == null) {
                    await DBHelper.instance.insertCustomer(customerData);
                  } else {
                    customerData['id'] = _editingCustomerId;
                    await DBHelper.instance.updateCustomer(customerData);
                  }
                  _fetchCustomers();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill in all fields", style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: Text(_editingCustomerId == null ? "Add" : "Update",style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  void _deleteCustomer(int customerId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
         backgroundColor: Colors.grey.shade200,
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this customer?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel kare toh dialog band ho jaye
              child: Text("Cancel", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () async {
                await DBHelper.instance.deleteCustomer(customerId);
                _fetchCustomers();
                Navigator.pop(context); // Dialog close karna
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),
      appBar: AppBar(
        title: Text('Customers '),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () => _showCustomerDialog(),
          ),
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          final customer = _customers[index];
          return Card(
            color: Colors.grey.shade200,
            child: ListTile(
              title: Text(customer['name']),
              subtitle: Text('Phone: ${customer['phone']}\nEmail: ${customer['email'] ?? 'N/A'}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showCustomerDialog(customerId: customer['id']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCustomer(customer['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
