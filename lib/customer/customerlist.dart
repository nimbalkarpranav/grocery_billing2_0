import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/customer/customerAdd.dart';
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
  int? _editingId;

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

  Future<void> _addOrUpdateCustomer() async {
    final String name = _nameController.text;
    final String phone = _phoneController.text;
    final String email = _emailController.text;

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name and Phone are required!')),
      );
      return;
    }

    final customerData = {'name': name, 'phone': phone, 'email': email};

    if (_editingId == null) {
      await DBHelper.instance.insertCustomer(customerData);
    } else {
      await DBHelper.instance.updateCustomer(_editingId!, customerData); // Fix applied ✅
    }

    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _editingId = null;
    _fetchCustomers();
  }


  Future<void> _deleteCustomer(int id) async {
    await DBHelper.instance.deleteCustomer(id);
    _fetchCustomers();
  }

  void _editCustomer(Map<String, dynamic> customer) {
    setState(() {
      _editingId = customer['id'];
      _nameController.text = customer['name'];
      _phoneController.text = customer['phone'];
      _emailController.text = customer['email'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),

      appBar: AppBar(title: Text('Customers List '),

        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCustomer()),
              );
              if (result == true) {
                CustomersPage(); // Refresh products
              }
            },
          ),
        ],
      backgroundColor: Colors.blueAccent,
      ),
      body: Container(color: Colors.blueAccent.shade100,
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     children: [
            //       TextField(
            //         controller: _nameController,
            //         decoration: InputDecoration(labelText: 'Name'),
            //       ),
            //       TextField(
            //         controller: _phoneController,
            //         decoration: InputDecoration(labelText: 'Phone'),
            //       ),
            //       TextField(
            //         controller: _emailController,
            //         decoration: InputDecoration(labelText: 'Email (optional)'),
            //       ),
            //       SizedBox(height: 10),
            //       ElevatedButton(
            //         onPressed: _addOrUpdateCustomer,
            //         child: Text(_editingId == null ? 'Add Customer' : 'Update Customer'),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: _customers.length,
                  itemBuilder: (context, index) {
                    final customer = _customers[index];
                    return Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(

                          title: Text(customer['name']),
                          subtitle: Text('Phone: ${customer['phone']} \nEmail: ${customer['email'] ?? 'N/A'}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editCustomer(customer),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteCustomer(customer['id']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
