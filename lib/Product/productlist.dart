import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Billing_page/product_billing.dart';
import 'package:grocery_billing2_0/drawer/drawer.dart';
import '../DataBase/database.dart';
import '../Payment Details Page/PaymentDetailsADD.dart';
import 'addproduct.dart';
import '../Screens/profileScreen.dart';
import 'editeProduct.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> products = [];

  /// Fetch products from the database
  ///
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching products'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  /// Delete product from the database
  // Future<void> deleteProduct(int id) async {
  //   final confirmation = await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Delete Product'),
  //         content: Text('Are you sure you want to delete this product?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, false),
  //             child: Text('Cancel', style: TextStyle(color: Colors.grey)),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context, true);
  //             },
  //             child: Text('Delete', style: TextStyle(color: Colors.red)),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //
  //   if (confirmation == true) {
  //     await DBHelper.instance.deleteProduct(id);
  //     fetchProducts(); // Refresh the list after deletion
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Product deleted successfully'),
  //       duration: Duration(seconds: 2),
  //     ));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),
      appBar: AppBar(
        title: Text('Product List', style: TextStyle(fontSize: 24)),
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
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onLongPress: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProductPage(product: product),
                    ),
                  );
                  if (result == true) {
                    fetchProducts(); // Refresh products after editing
                  }
                },
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  product['name'],
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MRP: ${product['sellPrice']}',
                        style: TextStyle(fontSize: 10)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sell Price: ${product['price']}',
                      style: TextStyle(fontSize: 10),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteProduct(product['id']);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  //addToCart(product); // Add product to cart
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
