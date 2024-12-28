import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Home_screen/productlist.dart';
import 'package:grocery_billing2_0/profile.dart';
import '../DataBase/database.dart';
import '../addproduct.dart';
  // Import the Product List page if you have one

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
          ],
        ),
      ),
      body: Center(
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Welcome \n   to the\nDashboard', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blueAccent),),
        ),
      ),
      // SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         // Title
      //         Text(
      //           'Welcome to the Dashboard',
      //           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      //         ),
      //         SizedBox(height: 40),
      //
      //         // Buttons
      //         ElevatedButton(
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: Colors.blueAccent, // Button color
      //             padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Button padding
      //             textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //           ),
      //           onPressed: () {
      //             // Navigate to the Product List page
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => ProductListPage()),
      //             );
      //           },
      //           child: Text('View Product List'),
      //         ),
      //         SizedBox(height: 20),
      //         ElevatedButton(
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: Colors.green, // Button color
      //             padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Button padding
      //             textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //           ),
      //           onPressed: () {
      //             // Navigate to Add Product page
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => AddProductPage()),
      //             );
      //           },
      //           child: Text('Add New Product'),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
