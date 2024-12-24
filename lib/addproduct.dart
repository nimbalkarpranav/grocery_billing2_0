import 'package:flutter/material.dart';
import 'DataBase/database.dart';
import 'addC.dart';


class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController sellPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCategory; // For the dropdown
  List<String> categories = []; // To store categories

  /// Fetch categories from the database
  Future<void> fetchCategories() async {
    final data = await DBHelper.instance.fetchCategories();
    setState(() {
      categories = data.map((e) => e['name'] as String).toList();
    });
  }

  /// Save product to the database
  void saveProduct(BuildContext context) async {
    if (_formKey.currentState!.validate() && selectedCategory != null) {
      final product = {
        'name': nameController.text,
        'price': double.parse(priceController.text),
        'sellPrice': double.parse(sellPriceController.text),
        'category': selectedCategory,
        'description': descriptionController.text,
      };

      await DBHelper.instance.insertProduct(product);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // Navigate to AddCategoryPage
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryPage()),
              );
              fetchCategories(); // Refresh categories after adding a new one
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )),
                validator: (value) => value!.isEmpty ? 'Enter Product Name' : null,
              ),
              SizedBox(height: 7,),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price',
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10)
                     
                   )
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter Price' : null,
              ),
              SizedBox(height: 7,),
              TextFormField(
                controller: sellPriceController,
                decoration: InputDecoration(labelText: 'Sell Price',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)

                    )),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter Sell Price' : null,
              ),
              SizedBox(height: 7,),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                borderRadius: BorderRadius.circular(10),

                items: categories.map((category) {
                  return DropdownMenuItem(

                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Category',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)

                    )),
                validator: (value) => value == null ? 'Select a Category' : null,
              ),
              SizedBox(height: 7,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)

                    )),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => saveProduct(context),
                child: Text('Save Product'),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
