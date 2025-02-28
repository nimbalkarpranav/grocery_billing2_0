import 'package:flutter/material.dart';
import '../DataBase/database.dart';
import 'InvoiceModel.dart';

class InvoiceList extends StatefulWidget {
  @override
  _InvoiceListState createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  final DBHelper _dbHelper = DBHelper.instance;
  List<Map<String, dynamic>> _invoices = [];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }
  //==============================

  Future<void> _loadInvoices() async {
    final invoices = await _dbHelper.fetchInvoices();
    setState(() {
      _invoices = invoices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: _invoices.length,
        itemBuilder: (context, index) {
          final invoice = _invoices[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text('Invoice #${invoice['id']}'),
              subtitle: Text('Total: ₹${invoice['total_amount']}'),
              trailing: Text('Date: ${invoice['date']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoiceDetailsPage(invoiceId: invoice['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}