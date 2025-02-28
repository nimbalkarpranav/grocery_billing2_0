import 'package:flutter/material.dart';
import '../DataBase/database.dart';
import '../Product/addproduct.dart';
import '../Product/productlist.dart';
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
  bool _showCustomerList = false;
  bool _showProductList = false;

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
      _showCustomerList = query.isNotEmpty;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
          product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      _showProductList = query.isNotEmpty;
    });
  }

  void _selectCustomer(int id) {
    setState(() {
      _selectedCustomer = id;
      customerSearchController.text =
      _customers.firstWhere((c) => c['id'] == id)['name'];
      _showCustomerList = false;
    });
  }

  void _addProductToInvoice(Map<String, dynamic> product) {
    setState(() {
      final existingProduct = _selectedProducts.firstWhere(
            (p) => p['id'] == product['id'],
        orElse: () => {},
      );
      if (existingProduct.isNotEmpty) {
        existingProduct['quantity']++;
      } else {
        _selectedProducts.add({...product, 'quantity': 1});
      }
      _calculateTotalAmount();
      productSearchController.clear();
      _showProductList = false;
    });
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      _selectedProducts[index]['quantity'] += change;
      if (_selectedProducts[index]['quantity'] <= 0) {
        _selectedProducts.removeAt(index);
      }
      _calculateTotalAmount();
    });
  }

  void _calculateTotalAmount() {
    setState(() {
      _totalAmount = _selectedProducts.fold(
          0.0,
              (sum, product) =>
          sum + (product['price'] * product['quantity']));
    });
  }

  Widget tableCell(String text, [bool isHeader = false]) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
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
            onPressed: () {},
            child: Text('SAVE',
                style: TextStyle(color: Colors.white, fontSize: 17)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(children: [
              // Customer Input Field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: customerSearchController,
                      decoration: InputDecoration(
                        labelText: "Customer Name",
                        prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onTap: () => setState(() => _showCustomerList = true),
                      onChanged: _filterCustomers,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomersPage()));
                    },
                    icon: Icon(Icons.add_circle, color: Colors.green, size: 30),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Product Input Field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: productSearchController,
                      decoration: InputDecoration(
                        labelText: "Product Name",
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onTap: () => setState(() => _showProductList = true),
                      onChanged: _filterProducts,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductListPage()));
                    },
                    icon: Icon(Icons.add_circle, color: Colors.blue, size: 30),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Center(
                child: Text("Products Details",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueAccent)),
              ),
              SizedBox(height: 10),

              // Invoice Table
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(color: Colors.grey),
                        columnWidths: {
                          0: FixedColumnWidth(30),
                          1: FlexColumnWidth(),
                          2: FixedColumnWidth(113),
                          3: FixedColumnWidth(60),
                          4: FixedColumnWidth(60),
                        },
                        children: [
                          TableRow(
                            decoration:
                            BoxDecoration(color: Colors.blueAccent.shade100),
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
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle,size: 20,
                                          color: Colors.red),
                                      onPressed: () => _updateQuantity(i, -1),
                                    ),
                                    Text(_selectedProducts[i]['quantity']
                                        .toString()),
                                    IconButton(
                                      icon: Icon(Icons.add_circle,size: 20,
                                          color: Colors.green),
                                      onPressed: () => _updateQuantity(i, 1),
                                    ),
                                  ],
                                ),
                              ),
                              tableCell('₹${_selectedProducts[i]['price']}'),
                              tableCell(
                                  '₹${_selectedProducts[i]['price'] * _selectedProducts[i]['quantity']}'),
                            ]),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('Total: ₹$_totalAmount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ]),

            // Customer List Popup
            if (_showCustomerList)
              Positioned(
                top: 55,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: _filteredCustomers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_filteredCustomers[index]['name']),
                          onTap: () =>
                              _selectCustomer(_filteredCustomers[index]['id']),
                        );
                      },
                    ),
                  ),
                ),
              ),

            // Product List Popup
            if (_showProductList)
              Positioned(
                top: 135,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_filteredProducts[index]['name']),
                          onTap: () =>
                              _addProductToInvoice(_filteredProducts[index]),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
