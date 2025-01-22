import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../DataBase/database.dart'; // Assuming the DBHelper class is in a separate file

class InvoiceBillingPage extends StatefulWidget {
  @override
  _InvoiceBillingPageState createState() => _InvoiceBillingPageState();
}

class _InvoiceBillingPageState extends State<InvoiceBillingPage> {
  final DBHelper _dbHelper = DBHelper.instance;
  final List<Map<String, dynamic>> _products = [];
  final List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = []; // For filtering customers
  List<Map<String, dynamic>> _filteredProducts = []; // For filtering products
  int? _selectedCustomer;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController(); // For product name
  final List<Map<String, dynamic>> _selectedProducts = [];
  double _totalAmount = 0.0;
  Map<String, dynamic>? _selectedProductForInvoice;
  int _productQuantity = 1;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final products = await _dbHelper.fetchProducts();
    final customers = await _dbHelper.fetchCustomers();
    setState(() {
      _products.addAll(products);
      _customers.addAll(customers);
      _filteredCustomers.addAll(customers);
      _filteredProducts.addAll(products); // Load products for search
    });
  }

  void _calculateTotalAmount() {
    _totalAmount = _selectedProducts.fold(
        0.0,
            (sum, product) =>
        sum + ((product['price'] ?? 0) * (product['quantity'] ?? 0)));
    setState(() {});
  }

  // Filter customers based on search input
  void _filterCustomers(String query) {
    final filtered = _customers.where((customer) {
      final name = customer['name'].toString().toLowerCase();
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery);
    }).toList();
    setState(() {
      _filteredCustomers.clear();
      _filteredCustomers.addAll(filtered);
    });
  }

  // Filter products based on search input
  void _filterProducts(String query) {
    final filtered = _products.where((product) {
      final name = product['name'].toString().toLowerCase();
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery);
    }).toList();
    setState(() {
      _filteredProducts.clear();
      _filteredProducts.addAll(filtered);
    });
  }

  Future<void> _addCustomer() async {
    final customerName = _customerNameController.text.trim();
    if (customerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid customer name.')),
      );
      return;
    }

    // Check if customer already exists
    final existingCustomer = _customers.firstWhere(
          (customer) => customer['name'].toLowerCase() == customerName.toLowerCase(),
      orElse: () => {},
    );

    if (existingCustomer.isNotEmpty) {
      setState(() {
        _selectedCustomer = existingCustomer['id'];
      });
    } else {
      // Add new customer
      final newCustomerId = await _dbHelper.insertCustomer({
        'name': customerName,
        'phone': '', // Optionally, add other details
        'email': '',
      });

      // Reload customers and select the new one
      final customers = await _dbHelper.fetchCustomers();
      setState(() {
        _customers.clear();
        _customers.addAll(customers);
        _filteredCustomers.clear();
        _filteredCustomers.addAll(customers);
        _selectedCustomer = newCustomerId;
      });
    }

    _customerNameController.clear();
  }

  // Add product to invoice
  Future<void> _addProductToInvoice() async {
    if (_selectedProductForInvoice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a product to add.')),
      );
      return;
    }

    final existing = _selectedProducts.indexWhere(
          (p) => p['id'] == _selectedProductForInvoice!['id'],
    );

    if (existing >= 0) {
      setState(() {
        _selectedProducts[existing]['quantity'] = _productQuantity;
      });
    } else {
      setState(() {
        _selectedProducts.add({
          ..._selectedProductForInvoice!,
          'quantity': _productQuantity,
        });
      });
    }

    _calculateTotalAmount();
    setState(() {
      _selectedProductForInvoice = null; // Reset after adding
      _productQuantity = 1; // Reset quantity
    });
  }

  Future<void> _saveInvoice() async {
    if (_selectedCustomer == null || _selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select or add a customer and add products.')),
      );
      return;
    }

    final invoiceId = await _dbHelper.insertPaymentDetail({
      'customer_id': _selectedCustomer,
      'amount': _totalAmount,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invoice #$invoiceId saved successfully!')),
    );

    setState(() {
      _selectedCustomer = null;
      _selectedProducts.clear();
      _totalAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Billing'),
        actions: [
          TextButton(
            onPressed: _saveInvoice,
            child: Text('Save Invoice'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Customer Name Input
                TextField(
                  controller: _customerNameController,
                  onChanged: _filterCustomers, // Trigger search for customers
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addCustomer,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                if (_filteredCustomers.isNotEmpty) ...[
                  Container(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = _filteredCustomers[index];
                        return ListTile(
                          title: Text(customer['name']),
                          onTap: () {
                            setState(() {
                              _selectedCustomer = customer['id'];
                              _customerNameController.text = customer['name'];
                              _filteredCustomers.clear(); // Hide suggestions
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
                SizedBox(height: 16),

                // Product Name Input
                TextField(
                  controller: _productNameController,
                  onChanged: _filterProducts, // Trigger search for products
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(height: 8),
                if (_filteredProducts.isNotEmpty) ...[
                  Container(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ListTile(
                          title: Text(product['name']),
                          subtitle: Text('₹${product['price']}'),
                          onTap: () {
                            setState(() {
                              _selectedProductForInvoice = product;
                              _productNameController.text = product['name'];
                              _filteredProducts.clear(); // Hide suggestions
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('₹${product['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _selectedProductForInvoice = product;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          if (_selectedProductForInvoice != null) ...[
            // Footer section displaying selected product and quantity options
            Divider(),
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Product:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _selectedProductForInvoice!['name'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Price: ₹${_selectedProductForInvoice!['price']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (_productQuantity > 1) {
                            setState(() {
                              _productQuantity--;
                            });
                          }
                        },
                      ),
                      Text('Quantity: $_productQuantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _productQuantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _addProductToInvoice,
                    child: Text('Add Product to Invoice'),
                  ),
                ],
              ),
            ),
          ],
          Divider(),
          Text(
            'Total Amount: ₹$_totalAmount',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
