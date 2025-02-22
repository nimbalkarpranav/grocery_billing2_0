import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Product/productlist.dart';
import 'package:grocery_billing2_0/Payment%20Details%20Page/Payment%20Details%20list.dart';
import 'package:grocery_billing2_0/drawer/drawer.dart';

import '../customer/customerlist.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget buildDashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
     drawer: drawerPage(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two cards per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            buildDashboardCard(
              icon: Icons.list,
              title: 'Product',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListPage()),
                );
              },
            ),
            buildDashboardCard(
              icon: Icons.people,
              title: 'Customer',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomersPage()), // Replace with actual page
                );
              },
            ),
            buildDashboardCard(
              icon: Icons.payment,
              title: 'Payment Details',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentDetailsPage()), // Replace with actual page
                );
              },
            ),
            buildDashboardCard(
              icon: Icons.settings,
              title: 'Settings',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListPage()), // Replace with actual page
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
