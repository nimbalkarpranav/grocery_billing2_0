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
      appBar: AppBar(
        title: Text('Products', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // Navigate to AddProductPage when the icon is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductPage()),
            ).then((_) {
              // After returning from AddProductPage, fetch the latest products
              fetchProducts();
            });
          },
        ),
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
              leading: Icon(Icons.add, color: Colors.blueAccent),
              title: Text('Add Product', style: TextStyle(fontSize: 18)),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
                fetchProducts(); // Refresh the product list after adding a new product
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: products.isEmpty
            ? Center(
          child: Text(
            'No Products Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    product['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price: \$${product['price']}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Sell Price: \$${product['sellPrice']}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Category: ${product['category']}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  tileColor: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
