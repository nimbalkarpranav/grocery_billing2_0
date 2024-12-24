import 'package:flutter/material.dart';
import '../DataBase/database.dart';
import '../addproduct.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    final data = await DBHelper.instance.fetchProducts();
    setState(() {
      products = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Product'),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
                fetchProducts(); // Refresh the product list
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: products.isEmpty
            ? Center(child: Text('No Products Found'))
            : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: Text(product['name']),
                subtitle: Text(
                  'Price: \$${product['price']} - Sell Price: \$${product['sellPrice']}',
                ),
                tileColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
