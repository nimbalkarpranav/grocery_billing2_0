import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Billing_page/product_billing.dart';
import 'package:grocery_billing2_0/drawer/drawer.dart';
import '../DataBase/database.dart';
import 'addproduct.dart';
import 'editeProduct.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> products = [];

  /// Fetch products from the database
  Future<void> fetchProducts() async {
    try {
      final data = await DBHelper.instance.fetchProducts();
      if (mounted) {
        setState(() {
          products = data;
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products')),
      );
    }
  }

  /// Delete product from the database
  Future<void> deleteProduct(int id) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await DBHelper.instance.deleteProduct(id);
      fetchProducts(); // Refresh list
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),
      appBar: AppBar(
        title: Text('Product List', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
              if (result == true) {
                fetchProducts(); // Refresh products
              }
            },
          ),
        ],
      ),
      body: products.isEmpty
          ? Center(
        child: Text(
          'No Products Found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: products.length,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent.shade100, Colors.blueAccent.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    product['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category: ${product['category']}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.yellowAccent),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'MRP: ₹${product['sellPrice']}',
                        style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Sell Price: ₹${product['price']}',
                        style: TextStyle(fontSize: 14, color: Colors.greenAccent, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductPage(product: product),
                          ),
                        ).then((result) {
                          if (result == true) {
                            fetchProducts(); // Refresh products after editing
                          }
                        });
                      } else if (value == 'Delete') {
                        deleteProduct(product['id']); // Delete product
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'Edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
