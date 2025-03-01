import 'package:flutter/material.dart';
import '../DataBase/database.dart';

class InvoiceDetailsPage extends StatefulWidget {
  final int invoiceId;

  InvoiceDetailsPage({required this.invoiceId});

  @override
  _InvoiceDetailsPageState createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends State<InvoiceDetailsPage> {
  final DBHelper _dbHelper = DBHelper.instance;
  Map<String, dynamic>? _invoiceWithCustomer;
  List<Map<String, dynamic>> _invoiceItems = [];

  @override
  void initState() {
    super.initState();
    _loadInvoiceDetails();
  }

  Future<void> _loadInvoiceDetails() async {
    try {
      final invoiceWithCustomer = await _dbHelper.fetchInvoiceWithCustomer(widget.invoiceId);
      final invoiceItems = await _dbHelper.fetchInvoiceItems(widget.invoiceId);
      setState(() {
        _invoiceWithCustomer = invoiceWithCustomer;
        _invoiceItems = invoiceItems;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load invoice details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_invoiceWithCustomer == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Invoice Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(onPressed: () {
            
          }, icon: Icon(Icons.local_print_shop_outlined,size: 34,))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Receipt Header
            Center(
              child: Text(
                'Invoice ${_invoiceWithCustomer!['invoice_id']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Date: ${_invoiceWithCustomer!['date']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Customer Details
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildDetailRow('Name', '${_invoiceWithCustomer!['customer_name']}'),
                    _buildDetailRow('Phone', '${_invoiceWithCustomer!['customer_phone']}'),
                    _buildDetailRow('Email', '${_invoiceWithCustomer!['customer_email']}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Products Table
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: {
                        0: FlexColumnWidth(2), // Product Name
                        1: FlexColumnWidth(1), // Price
                        2: FlexColumnWidth(1), // Quantity
                        3: FlexColumnWidth(1), // Total
                      },
                      children: [
                        // Table Header
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.shade100,
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Price',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Qty',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        // Product Rows
                        for (var item in _invoiceItems)
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  item['product_name'],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '₹${item['price']}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  item['quantity'].toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '₹${item['quantity'] * item['price']}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Total Amount
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildDetailRow('Subtotal', '₹${_invoiceWithCustomer!['total_amount']}'),
                    _buildDetailRow('Grand Total', '₹${_invoiceWithCustomer!['total_amount']}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Thank You! Visit again!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Powered By Pranav Dudhal',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}