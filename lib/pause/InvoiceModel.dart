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
      ),
      body: Container(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Invoice Details Table
                Table(
                  border: TableBorder.all(color: Colors.blueAccent, width: 2),
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Invoice ID:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${_invoiceWithCustomer!['invoice_id']}', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Date:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${_invoiceWithCustomer!['date']}', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Total Amount:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('₹${_invoiceWithCustomer!['total_amount']}', style: TextStyle(fontSize: 18, color: Colors.green)),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Customer Details Table
                Table(
                  border: TableBorder.all(color: Colors.blueAccent, width: 2),
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Customer Name:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${_invoiceWithCustomer!['customer_name']}', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Phone:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${_invoiceWithCustomer!['customer_phone']}', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Email:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${_invoiceWithCustomer!['customer_email']}', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Products Table
                Text(
                  'Products:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                SizedBox(height: 8),
                _invoiceItems.isEmpty
                    ? Center(child: Text('No products available.', style: TextStyle(fontSize: 18, color: Colors.grey)))
                    : Table(
                  border: TableBorder.all(color: Colors.blueAccent, width: 2),
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Product ID', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Price', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        ),
                      ],
                    ),
                    ..._invoiceItems.map((item) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${item['product_id']}', style: TextStyle(fontSize: 18)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${item['quantity']}', style: TextStyle(fontSize: 18)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('₹${item['price']}', style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),

                // Print Button
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add print functionality here
                    },
                    icon: Icon(Icons.print),
                    label: Text("Get Print"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.blueAccent,
                      elevation: 8,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),//======================
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}