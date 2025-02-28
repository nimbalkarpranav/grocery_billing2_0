import 'package:flutter/material.dart';
import '../DataBase/database.dart';
import '../drawer/drawer.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> products = [];
  List<String> categories = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();

  int? _editingProductId;
  String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
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
    }
  }

  Future<void> fetchCategories() async {
    try {
      final data = await DBHelper.instance.fetchCategories();
      if (mounted) {
        setState(() {
          categories = data.map<String>((cat) => cat['name'].toString()).toList();
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
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
            icon: Icon(Icons.add, size: 33),
            onPressed: () => _showProductDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: 2,
            child: ListTile(
              title: Text(product['name']),
              subtitle: Text("Category: ${product['category']}\nMRP: ₹${product['price']} | Selling Price: ₹${product['sellPrice']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showProductDialog(productId: product['id']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(product['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DBHelper.instance.deleteProduct(productId);
              fetchProducts();
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showProductDialog({int? productId}) async {
    if (categories.isEmpty) {
      await fetchCategories(); // Fetch categories if the list is empty
    }

    if (productId != null) {
      final product = products.firstWhere((p) => p['id'] == productId);
      _nameController.text = product['name'];
      _selectedCategory = categories.contains(product['category']) ? product['category'] : null;
      _mrpController.text = product['price'].toString();
      _sellPriceController.text = product['sellPrice'].toString();
      _editingProductId = productId;
    } else {
      _nameController.clear();
      _selectedCategory = null;
      _mrpController.clear();
      _sellPriceController.clear();
      _editingProductId = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text(_editingProductId == null ? "Add Product" : "Edit Product"),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Product Name",
                        prefixIcon: Icon(Icons.label, color: Colors.blueAccent),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) => value!.isEmpty ? 'Required field' : null,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) => setInnerState(() => _selectedCategory = value),
                      validator: (value) => value == null ? 'Please select a category' : null,
                    ),
                    TextButton(
                      child: Text('Add New Category', style: TextStyle(color: Colors.blueAccent)),
                      onPressed: () async {
                        await _addCategory();
                        setInnerState(() {});
                      },
                    ),
                    TextFormField(
                      controller: _mrpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "MRP",
                        prefixIcon: Icon(Icons.money, color: Colors.blueAccent),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Required field';
                        if (double.tryParse(value) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _sellPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Selling Price",
                        prefixIcon: Icon(Icons.attach_money, color: Colors.blueAccent),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Required field';
                        if (double.tryParse(value) == null) return 'Invalid number';
                        final mrp = double.tryParse(_mrpController.text) ?? 0;
                        final sellPrice = double.tryParse(value) ?? 0;
                        if (sellPrice > mrp) return 'Cannot exceed MRP';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final mrp = double.parse(_mrpController.text);
                      final sellPrice = double.parse(_sellPriceController.text);

                      if (sellPrice > mrp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Selling price cannot exceed MRP'), backgroundColor: Colors.red),
                        );
                        return;
                      }

                      Map<String, dynamic> productData = {
                        'name': _nameController.text,
                        'category': _selectedCategory,
                        'price': mrp,
                        'sellPrice': sellPrice,
                      };

                      if (_editingProductId == null) {
                        await DBHelper.instance.insertProduct(productData);
                      } else {
                        productData['id'] = _editingProductId;
                        await DBHelper.instance.updateProduct(productData);
                      }

                      fetchProducts();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(_editingProductId == null ? 'Add' : 'Update', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addCategory() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Category'),
        content: TextField(
          controller: _newCategoryController,
          decoration: InputDecoration(
            labelText: 'Category Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_newCategoryController.text.isNotEmpty) {
                await DBHelper.instance.insertCategory({
                  'name': _newCategoryController.text
                });
                await fetchCategories();
                setState(() => _selectedCategory = _newCategoryController.text);
                _newCategoryController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}