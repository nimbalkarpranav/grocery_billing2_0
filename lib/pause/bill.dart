import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../DataBase/database.dart';
import '../customer/customerlist.dart';
import '../drawer/drawer.dart';

class InvoiceBillingPage extends StatefulWidget {
  @override
  _InvoiceBillingPageState createState() => _InvoiceBillingPageState();
}

class _InvoiceBillingPageState extends State<InvoiceBillingPage> {
  final DBHelper _dbHelper = DBHelper.instance;
  final List<Map<String, dynamic>> _products = [];
  final List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];
  int? _selectedCustomer;
  double _totalAmount = 0.0;
  List<Map<String, dynamic>> _selectedProducts = [];
  Map<String, dynamic>? _selectedProductForInvoice;
  int _productQuantity = 1;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _navigateToCustomerList() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomersPage()),
    );

    if (result == true) {
      _loadInitialData();
    }
  }

  Future<void> _loadInitialData() async {
    final customers = await _dbHelper.fetchCustomers();
    final products = await _dbHelper.fetchProducts();

    setState(() {
      _customers.clear();
      _customers.addAll(customers);
      _filteredCustomers = List.from(_customers);
      _products.clear();
      _products.addAll(products);
    });
  }

  void _filterCustomers(String query) {
    setState(() {
      _filteredCustomers = _customers
          .where((customer) =>
          customer['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _calculateTotalAmount() {
    _totalAmount = _selectedProducts.fold(0.0, (sum, product) =>
    sum + ((product['price'] ?? 0) * (product['quantity'] ?? 0)));
    setState(() {});
  }

  Future<void> _saveInvoice() async {
    if (_selectedCustomer == null || _selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a customer and add products.')),
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
      drawer: drawerPage(),
      appBar: AppBar(
        title: Text('Invoice Billing'),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton(
            onPressed: _saveInvoice,
            child: Text('SAVE ', style: TextStyle(color: Colors.white, fontSize: 17)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 🔹 Search Bar for Customer Search
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search Customer",
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _filterCustomers,
            ),
            SizedBox(height: 10),

            // Customer Selection Dropdown
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Select Customer',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCustomer,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedCustomer = newValue;
                      });
                    },
                    items: _filteredCustomers.map<DropdownMenuItem<int>>((customer) {
                      return DropdownMenuItem<int>(
                        value: customer['id'],
                        child: Text(customer['name']),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.blueAccent, size: 30),
                  onPressed: _navigateToCustomerList,
                ),
              ],
            ),

            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Text('₹${product['price']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add, color: Colors.blueAccent),
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
              Divider(),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Product:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${_selectedProductForInvoice!['name']}'),
                    Text('Price: ₹${_selectedProductForInvoice!['price']}'),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedProducts.add({
                            ..._selectedProductForInvoice!,
                            'quantity': _productQuantity,
                          });
                          _calculateTotalAmount();
                          _selectedProductForInvoice = null;
                          _productQuantity = 1;
                        });
                      },
                      child: Text('Add to Invoice'),
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
      ),
    );
  }
}
