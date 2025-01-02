import 'package:flutter/material.dart';
import '../DataBase/database.dart';
import 'customerAdd.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  Future<void> fetchCustomers() async {
    setState(() {}); // Refresh the list
  }

  Future<void> deleteCustomer(int id) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Customer'),
          content: Text('Are you sure you want to delete this customer?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      await DBHelper.instance.deleteCustomer(id);
      fetchCustomers(); // Refresh the list
    }
  }

  Future<void> updateCustomer(Map<String, dynamic> customer) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: customer['name']);
        final phoneController = TextEditingController(text: customer['phone']);
        final emailController =
        TextEditingController(text: customer['email'] ?? '');

        return AlertDialog(
          title: Text('Update Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, {
                  'id': customer['id'],
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'email': emailController.text,
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await DBHelper.instance.updateCustomer(result);
      fetchCustomers(); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCustomerPage()),
              ).then((_) => fetchCustomers());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBHelper.instance.fetchCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No customers found.'));
          } else {
            final customers = snapshot.data!;
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  title: Text(customer['name']),
                  subtitle: Text(customer['phone']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteCustomer(customer['id']),
                  ),
                  onLongPress: () => updateCustomer(customer),
                );
              },
            );
          }
        },
      ),
    );
  }
}
