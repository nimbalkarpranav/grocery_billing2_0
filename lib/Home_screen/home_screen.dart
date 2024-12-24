import 'package:flutter/material.dart';
import '../DataBase/database.dart';
import '../addproduct.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final TextEditingController searchController = TextEditingController();

  // Fetching products from the database
  Future<void> fetchProducts() async {
    final data = await DBHelper.instance.fetchProducts(); // Ensure this fetches all necessary product details, including 'name' and 'category'
    setState(() {
      products = data;
      filteredProducts = data; // Initially show all products
    });
  }

  // Filtering products based on search query
  void filterProducts(String query) {
    final results = products.where((product) {
      final name = product['name'].toLowerCase();
      final category = product['category'].toLowerCase();
      final searchLower = query.toLowerCase();
      return name.contains(searchLower) || category.contains(searchLower);
    }).toList();

    setState(() {
      filteredProducts = results;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(() {
      filterProducts(searchController.text); // Update filtered products as user types
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Products',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            // Product List
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(child: Text('No Products Found'))
                  : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(product['name']),
                      subtitle: Text(
                        'Price: \$${product['price']} - Sell Price: \$${product['sellPrice']}\n'
                            'Category: ${product['category']}',
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
          ],
        ),
      ),
    );
  }
}
