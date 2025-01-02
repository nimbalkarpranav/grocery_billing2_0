import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Home_screen/home_screen.dart';

import '../Business/business.dart';
import '../Home_screen/EditPinDB/editpin.dart';
import '../Home_screen/productlist.dart';
import '../addproduct.dart';

import '../profile.dart';

class drawerPage extends StatefulWidget {
  const drawerPage({super.key});

  @override
  State<drawerPage> createState() => _drawerPageState();
}

class _drawerPageState extends State<drawerPage> {
  final dbHelper = DatabaseHelper.instance;

  Future<void> logout() async {
    try {
      // Clear user and PIN data
      await dbHelper.deleteAllUsers();
      print('All user data deleted');
      await dbHelper.deletePin();
      print('PIN deleted');

      // Navigate to the login screen
      Navigator.pop(context); // Close the drawer
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login', // Replace with your login route
            (route) => false, // Clear all previous routes
      );
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.blueAccent),
            title: Text('Dashboard', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blueAccent),
            title: Text('Profile', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blueAccent),
            title: Text('Business', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BusinessEdit()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list, color: Colors.blueAccent),
            title: Text('Product List', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductListPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.blueAccent),
            title: Text('Add Product', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.edit, color: Colors.blueAccent),
            title: Text('Edit Pin', style: TextStyle(fontSize: 18)),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(fontSize: 18)),
            onTap: logout, // Call logout method
          ),
        ],
      ),
    );
  }
}
