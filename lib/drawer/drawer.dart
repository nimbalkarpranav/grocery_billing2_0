import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/DataBase/database.dart';
import '../Product/productlist.dart';
import '../Screens/business.dart';
import '../Screens/home_screen.dart';
import '../Screens/profileScreen.dart';
import '../pause/bill.dart';
import '../pause/inviocebill.dart';


class drawerPage extends StatefulWidget {
  const drawerPage({super.key});

  @override
  State<drawerPage> createState() => _drawerPageState();
}

class _drawerPageState extends State<drawerPage> {
  final dbHelper = DBHelper.instance;

  Future<void> logout() async {
    try {
      int rowsAffected = await dbHelper.deletePin();
      print('PIN deleted for $rowsAffected user(s)');  // Debugging line

      if (rowsAffected > 0) {
        print('Navigating to Login Screen');  // Debugging line
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        throw Exception("No PIN found to delete");
      }
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
            leading: Icon(Icons.dashboard, color: Colors.blueAccent),
            title: Text('Billing paus ', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>InvoiceBillingPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.blueAccent),
            title: Text('Billing Invioce ', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>InvoiceListPage()),
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
          // ListTile(
          //   leading: Icon(Icons.add, color: Colors.blueAccent),
          //   title: Text('Add Product', style: TextStyle(fontSize: 18)),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => AddProductPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.edit, color: Colors.blueAccent),
          //   title: Text('Edit Pin', style: TextStyle(fontSize: 18)),
          // ),
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
