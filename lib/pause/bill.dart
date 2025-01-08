import 'package:flutter/material.dart';
import '../DataBase/database.dart'; // Your DBHelper for fetching products and customers
import 'billpose.dart'; // Import the BillPage

class InvoicePauseScreen extends StatefulWidget {
  @override
  _InvoicePauseScreenState createState() => _InvoicePauseScreenState();
}

class _InvoicePauseScreenState extends State<InvoicePauseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController scanProductController = TextEditingController();

  String? selectedCustomer;
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> selectedProducts = [];
  bool isLoadingCustomers = true;
  bool isLoadingProducts = true;
  List<Map<String, dynamic>> filteredProducts = []; // Filtered products list

  @override
  void initState() {
    super.initState();
    fetchCustomers();
    fetchProducts();
  }

  Future<void> fetchCustomers() async {
    final data = await DBHelper.instance.fetchCustomers();
    setState(() {
      customers = data;
      isLoadingCustomers = false;
    });
  }

  Future<void> fetchProducts() async {
    final data = await DBHelper.instance.fetchProducts();
    setState(() {
      products = data;
      filteredProducts = data; // Initially, show all products
      isLoadingProducts = false;
    });
  }

  void saveInvoice() {
    if (_formKey.currentState!.validate()) {
      // Gather invoice data
      final invoiceData = {
        'invoiceNumber': invoiceNumberController.text,
        'customerName': selectedCustomer,
        'selectedProducts': selectedProducts,
      };

      // Navigate to the BillPage and pass the invoice data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BillPage(invoiceData: invoiceData),
        ),
      );
    }
  }

  void addCustomer(String customerName) {
    if (customerName.isNotEmpty) {
      setState(() {
        customers.add({'name': customerName});
        selectedCustomer = customerName;
        customerNameController.clear();
      });
    }
  }

  void scanAndAddProduct(String productName) {
    final product = products.firstWhere(
          (prod) => prod['name'] == productName,
      orElse: () => {},
    );
    if (product.isNotEmpty) {
      setState(() {
        selectedProducts.add({
          'product': product,
          'quantity': 1,
        });
        // Clear the input after selection
        scanProductController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product not found')),
      );
    }
  }

  // Filter products based on the first letter typed
  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products; // Show all products if query is empty
      } else {
        filteredProducts = products
            .where((product) =>
            product['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  double calculateTotal() {
    double total = 0;
    for (var product in selectedProducts) {
      total += product['product']['price'] * product['quantity'];
    }
    return total;
  }

  Widget _buildProductTable() {
    return selectedProducts.isEmpty
        ? Center(child: Text('No products selected'))
        : DataTable(
      columns: [
        DataColumn(label: Text('ProductName')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Price')),
      ],
      rows: selectedProducts.map((product) {
        return DataRow(cells: [
          DataCell(Text(product['product']['name'])),
          DataCell(Text('${product['quantity']}')),
          DataCell(Text('${product['product']['price']}')),
        ]);
      }).toList(),
    );
  }

  void showCustomerList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Customer List'),
          content: isLoadingCustomers
              ? CircularProgressIndicator() // Show loading spinner while fetching
              : customers.isEmpty
              ? Text('No customers available')
              : SingleChildScrollView(
            // Wrap with SingleChildScrollView for scrollable content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: customers.map((customer) {
                return ListTile(
                  title: Text(customer['name'] ?? 'Unnamed'),
                  onTap: () {
                    setState(() {
                      selectedCustomer = customer['name'];
                      customerNameController.text = selectedCustomer!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pause Invoice'),
        actions: [
          TextButton(
            onPressed: saveInvoice,
            child: Text(
              'SAVE',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Invoice Number
              TextFormField(
                controller: invoiceNumberController,
                decoration: InputDecoration(
                  labelText: 'Invoice Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Please enter invoice number' : null,
              ),
              SizedBox(height: 16),

              // Customer Name + Button
              TextFormField(
                controller: customerNameController,
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: showCustomerList,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onFieldSubmitted: addCustomer,
              ),
              SizedBox(height: 16),

              // Scan Product Input + Camera Icon
              TextFormField(
                controller: scanProductController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      // Add logic to open camera for scanning if needed
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: filterProducts, // Call filter when typing
                onFieldSubmitted: scanAndAddProduct,
              ),
              SizedBox(height: 16),

              // Product Suggestions (always show filtered list)
              if (filteredProducts.isNotEmpty)
                Container(
                  height: 150, // Adjust height as needed
                  child: ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredProducts[index]['name']),
                        onTap: () {
                          scanProductController.text =
                          filteredProducts[index]['name'];
                          scanAndAddProduct(filteredProducts[index]['name']);
                        },
                      );
                    },
                  ),
                ),

              SizedBox(height: 16),

              // Product Table
              Text(
                'Selected Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildProductTable(),

              // Total Footer
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${calculateTotal().toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
