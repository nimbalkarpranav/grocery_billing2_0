import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Billing_page/product_billing.dart';
import 'package:grocery_billing2_0/drawer/drawer.dart';
import '../DataBase/database.dart';
import '../addproduct.dart';
import '../profile.dart';
import 'editeProduct.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> cart = []; // Local cart list

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching products'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  /// Check if the product is already in the cart
  bool isProductInCart(Map<String, dynamic> product) {
    return cart.any((item) => item['id'] == product['id']);
  }

  /// Add product to the cart
  // void addToCart(Map<String, dynamic> product) {
  //   if (!isProductInCart(product)) {
  //     setState(() {
  //       cart.add(product);
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('${product['name']} added to cart!'),
  //       duration: Duration(seconds: 2),
  //     ));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('${product['name']} is already in the cart!'),
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
            onPressed: () {
              // Navigate to BillingPage only if there are products in the cart
              if (cart.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>AddProductPage(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(''),
                  duration: Duration(seconds: 2),
                ));
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
                      builder: (context) => EditProductPage(product: product),
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
                    Text('MRP: ${product['price']}',
                        style: TextStyle(fontSize: 10)),


                   // Text('Category: ${product['category']}',
                     //   style: TextStyle(fontSize: 16)),
                  ],
                ),
               trailing:Text('Sell Price: ${product['sellPrice']}',style: TextStyle(fontSize: 10)),
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
