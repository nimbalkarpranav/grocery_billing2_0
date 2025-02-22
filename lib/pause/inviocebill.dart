import 'package:flutter/material.dart';
import '../DataBase/database.dart';

class InvoiceListPage extends StatefulWidget {
  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  List<Map<String, dynamic>> _invoices = [];

  @override
  void initState() {
    super.initState();
    _fetchInvoices();
  }

  Future<void> _fetchInvoices() async {
    final invoices = await DBHelper.instance.fetchPaymentDetails();
    setState(() {
      _invoices = invoices;
    });
  }

  void _navigateToDetail(int id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InvoiceDetailPage(invoiceId: id)),
    );

    if (result == true) {
      _fetchInvoices(); // Refresh the list if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _invoices.isEmpty
          ?
      Center(
        child: Text(
          'No Invoices Found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          :
      ListView.builder(
        itemCount: _invoices.length,
        itemBuilder: (context, index) {
          final invoice = _invoices[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            shadowColor: Colors.blueAccent.withOpacity(0.3),
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  '${invoice['id']}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                '${invoice['customer_name'] ?? 'Unknown Customer'}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'Date: ${invoice['date']}',
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
              onTap: () => _navigateToDetail(invoice['id']),
            ),
          );
        },
      )


    );
  }
}
class InvoiceDetailPage extends StatefulWidget {
  final int invoiceId;

  InvoiceDetailPage({required this.invoiceId});

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}



class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  Map<String, dynamic>? _invoice;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    // _fetchInvoiceDetails();
  }

  // Future<void> _fetchInvoiceDetails() async {
  //   final invoice = await DBHelper.instance.fetchInvoiceById(widget.invoiceId);
  //  final products = await DBHelper.instance.fetchInvoiceProducts(widget.invoiceId);
  //
  //   setState(() {
  //     _invoice = invoice;
  //     _products = products;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (_invoice == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Invoice Details'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Name: ${_invoice!['customer_name']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Date: ${_invoice!['date']}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Divider(),
              Text(
                'Products:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(product['product_name']),
                    subtitle: Text('Quantity: ${product['quantity']}'),
                    trailing: Text('₹${product['subtotal']}'),
                  );
                },
              ),
              Divider(),
              Text(
                'Total Amount: ₹${_invoice!['amount']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


