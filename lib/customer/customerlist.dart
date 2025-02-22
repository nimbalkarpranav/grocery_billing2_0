import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/drawer/drawer.dart';

import 'customerAdd.dart';
import 'customer_db.dart';
import 'customer_edit.dart';
import 'customer_model.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late Future<List<Customer>> _customers;

  @override
  void initState() {
    super.initState();
    _customers = cDatabaseHelper.instance.fetchCustomers();
  }

  void _deleteCustomer(int id) async {
    await cDatabaseHelper.instance.deleteCustomer(id);
    setState(() {
      _customers = cDatabaseHelper.instance.fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Custom background color
        title: Text(
          "Customer List",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: drawerPage(),
      body: FutureBuilder<List<Customer>>(
        future: _customers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No customers found"));
          }

          final customers = snapshot.data!;

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return Card(
                elevation: 5, // Adds a shadow for the card
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    customer.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    customer.phone,
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          // Navigate to the update page with customer details
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateCustomer(customer: customer),
                            ),
                          );
                          setState(() {
                            _customers = cDatabaseHelper.instance.fetchCustomers();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Confirm deletion
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Rounded corners for dialog
                              ),
                              title: Text("Delete Customer"),
                              content: Text("Are you sure you want to delete this customer?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteCustomer(customer.id!);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Addcustomer(),));
        },
        backgroundColor: Colors.blueAccent, // Custom color for the FAB
        child: Icon(Icons.add),
      ),
    );
  }
}
