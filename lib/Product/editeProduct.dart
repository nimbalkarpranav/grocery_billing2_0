import 'package:flutter/material.dart';
import '../DataBase/database.dart';
import '../drawer/drawer.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  EditProductPage({required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController sellPriceController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name']);
    priceController = TextEditingController(text: widget.product['price'].toString());
    sellPriceController = TextEditingController(text: widget.product['sellPrice'].toString());
    categoryController = TextEditingController(text: widget.product['category']);
  }

  Future<void> updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = {
        'id': widget.product['id'],
        'name': nameController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'sellPrice': double.tryParse(sellPriceController.text) ?? 0.0,
        'category': categoryController.text,
      };
      await DBHelper.instance.updateProduct(updatedProduct);
      Navigator.pop(context, true); // Pass `true` to indicate an update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerPage(),
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton(
            onPressed: updateProduct,
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Edit Product Details",
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Price cannot be empty' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: sellPriceController,
                decoration: InputDecoration(
                  labelText: 'Sell Price',
                  prefixIcon: Icon(Icons.money_off),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Sell Price cannot be empty' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 30),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: updateProduct,
              //     style: ElevatedButton.styleFrom(
              //       padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //       backgroundColor: Colors.blueAccent,
              //     ),
              //     child: Text(
              //       'Update Product',
              //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
