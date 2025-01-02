import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Home_screen/productlist.dart';
import 'package:grocery_billing2_0/profile.dart';
import '../addproduct.dart';
import '../Business/business.dart';
import 'EditPinDB/editpin.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  TextEditingController pinController = TextEditingController();

  void editPin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit PIN"),
        content: TextField(
          keyboardType: TextInputType.number,
          controller: pinController,
          obscureText: true,
          maxLength: 4,
          decoration: InputDecoration(hintText: "New PIN"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newPin = pinController.text;
              if (newPin.isNotEmpty && newPin.length == 4) {
                DatabaseHelper.instance.updatePin(newPin);
                Navigator.pop(context);
              } else {
                // Show error message if PIN is invalid
              }
            },
            child: Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blueAccent),
              title: Text('Profile ', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()), // Navigate to Product List page
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blueAccent),
              title: Text('Business ', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BusinessEdit()), // Navigate to Product List page
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list, color: Colors.blueAccent),
              title: Text('Product List', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListPage()), // Navigate to Product List page
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.add, color: Colors.blueAccent),
              title: Text('Add Product', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()), // Navigate to Add Product page
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.pin_outlined, color: Colors.blueAccent),
              title: Text('Edit Pin', style: TextStyle(fontSize: 18)),
              onTap:  editPin,
            ),
          ],
        ),
      ),
      body: Center(
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Welcome \n   to the\nDashboard', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blueAccent),),
        ),
      ),
    );
  }
}
