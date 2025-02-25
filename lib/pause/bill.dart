import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../DataBase/database.dart';
import '../Product/addproduct.dart';
import '../customer/customerlist.dart';
import '../drawer/drawer.dart';

class InvoiceBillingPage extends StatefulWidget {
  @override
  _InvoiceBillingPageState createState() => _InvoiceBillingPageState();
}

class _InvoiceBillingPageState extends State<InvoiceBillingPage> {
  final DBHelper _dbHelper = DBHelper.instance;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  List<Map<String, dynamic>> _selectedProducts = [];
  int? _selectedCustomer;
  double _totalAmount = 0.0;
  TextEditingController customerSearchController = TextEditingController();
  TextEditingController productSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final customers = await _dbHelper.fetchCustomers();
    final products = await _dbHelper.fetchProducts();
    setState(() {
      _customers = customers;
      _filteredCustomers = customers;
      _products = products;
      _filteredProducts = products;
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

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
          product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addProductToInvoice(Map<String, dynamic> product) {
    setState(() {
      final existingProduct = _selectedProducts.firstWhere(
              (p) => p['id'] == product['id'],
          orElse: () => {});
      if (existingProduct.isNotEmpty) {
        existingProduct['quantity']++;
      } else {
        _selectedProducts.add({...product, 'quantity': 1});
      }
      _calculateTotalAmount();
    });
  }

  void _calculateTotalAmount() {
    setState(() {
      _totalAmount = _selectedProducts.fold(
          0.0, (sum, product) => sum + (product['price'] * product['quantity']));
    });
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
            child: Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 17)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: customerSearchController,
                    decoration: InputDecoration(
                      labelText: "Customer Name",
                      prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: _filterCustomers,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomersPage()));
                  },
                  icon: Icon(Icons.add_circle, color: Colors.blueAccent, size: 30),
                ),
              ],
            ),
            _filteredCustomers.isNotEmpty && customerSearchController.text.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return ListTile(
                  title: Text(customer['name']),
                  onTap: () {
                    setState(() {
                      _selectedCustomer = customer['id'];
                      customerSearchController.text = customer['name'];
                      _filteredCustomers = [];
                    });
                  },
                );
              },
            )
                : SizedBox.shrink(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: productSearchController,
                    decoration: InputDecoration(
                      labelText: "Product Name",
                      prefixIcon: Icon(Icons.production_quantity_limits, color: Colors.blueAccent),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: _filterProducts,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage()));
                  },
                  icon: Icon(Icons.add_circle, color: Colors.green, size: 30),
                ),
              ],
            ),
            _filteredProducts.isNotEmpty && productSearchController.text.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('₹${product['price']}'),
                  onTap: () {
                    _addProductToInvoice(product);
                    productSearchController.clear();
                    setState(() => _filteredProducts = []);
                  },
                );
              },
            )
                : SizedBox.shrink(),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: {
                0: FixedColumnWidth(40),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(60),
                3: FixedColumnWidth(60),
                4: FixedColumnWidth(60),
                5: FixedColumnWidth(70),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blueAccent.shade100),
                  children: [
                    tableCell("#", true),
                    tableCell("Product", true),
                    tableCell("Qty", true),
                    tableCell("Price", true),
                    tableCell("Total", true),
                  ],
                ),
                for (var i = 0; i < _selectedProducts.length; i++)
                  TableRow(children: [
                    tableCell((i + 1).toString()),
                    tableCell(_selectedProducts[i]['name']),
                    tableCell(_selectedProducts[i]['quantity'].toString()),
                    tableCell('₹${_selectedProducts[i]['price']}'),
                    tableCell('₹${_selectedProducts[i]['price'] * _selectedProducts[i]['quantity']}'),
                  ]),
              ],
            ),
            SizedBox(height: 16),
            Text('Total: ₹$_totalAmount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget tableCell(String text, [bool isHeader = false]) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(text, style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal)),
    );
  }
}
