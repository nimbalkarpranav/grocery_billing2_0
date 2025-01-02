import 'package:flutter/material.dart';
import '../DataBase/database.dart';

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
        'id': widget.product['id'], // Keep the same ID
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
      appBar: AppBar(
        title: Text('Edit Product'),

        actions: [
          TextButton(onPressed: updateProduct,

          child: Text("Save"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name',
                ),

                validator: (value) =>
                value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Price cannot be empty' : null,
              ),
              TextFormField(
                controller: sellPriceController,
                decoration: InputDecoration(labelText: 'Sell Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Sell Price cannot be empty' : null,
              ),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //
              //   child: Text('Update Product'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
