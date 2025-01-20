import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Product/productlist.dart';
import '../DataBase/database.dart';
import '../Screens/newCat_Screen.dart';

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
    if (_formKey.currentState!.validate()) {
      await DBHelper.instance.insertProduct({
        'name': nameController.text,
        'price': double.parse(priceController.text),
        'sellPrice': double.parse(sellPriceController.text),
        'category': selectedCategory,
        'description': descriptionController.text,
      });

      // Return to the previous screen with success result
      Navigator.pop(context, true);
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
        title: Text('Add Product', style: TextStyle(fontSize: 22)),
        elevation: 4,
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton(
            onPressed: () => saveProduct(context),
            child: Text(
              'SAVE',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: nameController,
                labelText: 'Product Name',
                hintText: 'Enter the product name',
                validator: (value) =>
                value!.isEmpty ? 'Enter Product Name' : null,
              ),
              SizedBox(height: 10,),
              _buildTextField(
                controller: sellPriceController,
                labelText: 'MRP Price',
                hintText: 'Enter the selling price',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Enter Sell Price';
                  final sellPrice = double.tryParse(value);
                  final price = double.tryParse(priceController.text);

                  if (sellPrice == null || sellPrice <= 0) {
                    return 'Enter a valid Sell Price';
                  }

                  // Ensure Sell Price is greater than or equal to Price
                  if (price != null && sellPrice < price) {
                    return '';
                  }

                  return null;
                },
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: priceController,
                labelText: 'sell Price',
                hintText: 'Enter the price',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Enter Price';
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) return 'Enter a valid Price';
                  return null;
                },
              ),
              SizedBox(height: 10),

              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
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
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                        value == null ? 'Select a Category' : null,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          await
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCategoryPage()),
                          );
                          fetchCategories(); // Refresh categories
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Icon(Icons.add, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: descriptionController,
                labelText: 'Description',
                hintText: 'Enter a brief description',
                maxLines: 3,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable TextField Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
