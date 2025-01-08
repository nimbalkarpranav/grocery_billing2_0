import 'package:flutter/material.dart';

class BillPage extends StatelessWidget {
  final Map<String, dynamic> invoiceData;

  BillPage({required this.invoiceData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Bill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Display the Invoice Number
            Text(
              'Invoice Number: ${invoiceData['invoiceNumber']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            // Display the Customer Name
            Text(
              'Customer Name: ${invoiceData['customerName']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            // Display the Selected Products in a Table format
            Text(
              'Selected Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Displaying products in a DataTable
            DataTable(
              columns: [
                DataColumn(label: Text('ProductName')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Total')),
              ],
              rows: invoiceData['selectedProducts'].isEmpty
                  ? [
                DataRow(cells: [
                  DataCell(Text('No products selected')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                ])
              ]
                  : invoiceData['selectedProducts'].map<DataRow>((product) {
                double total = product['product']['price'] *
                    product['quantity']; // Calculate total for each product
                return DataRow(cells: [
                  DataCell(Text(product['product']['name'])),
                  DataCell(Text('${product['quantity']}')),
                  DataCell(Text('${product['product']['price']}')),
                  DataCell(Text('${total.toStringAsFixed(2)}')),
                ]);
              }).toList(),
            ),
            SizedBox(height: 16),

            // Display the total bill
            Text(
              'Total Amount: ${calculateTotal(invoiceData['selectedProducts'])}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Calculate the total amount for all selected products
  double calculateTotal(List<dynamic> selectedProducts) {
    double total = 0;
    for (var product in selectedProducts) {
      total += product['product']['price'] * product['quantity'];
    }
    return total;
  }
}
