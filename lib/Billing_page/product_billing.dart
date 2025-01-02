import 'package:flutter/material.dart';
import 'CustomerDetailsPage.dart';

class BillingPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  BillingPage({required this.cart});

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  double taxPercentage = 0.0; // Store tax as a percentage
  double discount = 0.0;

  // Method to build the summary rows
  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Table(
      children: [
        TableRow(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate subtotal considering null values for price and quantity
    double subtotal = widget.cart.fold(0, (total, product) {
      double price = product['price'] ?? 0.0; // Default to 0.0 if price is null
      int quantity = product['quantity'] ?? 1; // Default to 1 if quantity is null
      return total + (price * quantity);
    });

    double tax = (subtotal * taxPercentage) / 100; // Calculate tax as a percentage of subtotal
    double grandTotal = subtotal + tax - discount;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {

              // Handle adding a new product
            },
            child: Icon(Icons.add),
          ),
        ],
        title: Text('Billing Page', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:   Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(
                        color: Colors.black,
                        width: 1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      columnWidths: {
                        0: FixedColumnWidth(120),
                        1: FixedColumnWidth(120),
                        2: FixedColumnWidth(100),
                      },
                      children: [
                        // Table Header Row
                        TableRow(
                          decoration: BoxDecoration(

                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Text(
                                'Name',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Category',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Price',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        // Loop through each product and display it in a table row
                        for (var product in widget.cart)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['name'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['category'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '₹${product['sellPrice']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),

          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Subtotal, Tax, Discount, and Grand Total Table
                _buildSummaryRow('Subtotal:', '₹${subtotal.toStringAsFixed(2)}', isBold: true),
                _buildSummaryRow('Tax:', '₹${tax.toStringAsFixed(2)}'),
                _buildSummaryRow('Discount:', '₹${discount.toStringAsFixed(2)}'),
                _buildSummaryRow('Grand Total:', '₹${grandTotal.toStringAsFixed(2)}', isBold: true),

                SizedBox(height: 16),

                // Action Buttons for Adding Tax and Discount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Add Tax Percentage'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: 'Enter tax percentage'),
                              onChanged: (value) {
                                setState(() {
                                  taxPercentage = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Add Tax', style: TextStyle(color: Colors.blueAccent)),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Add Discount'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: 'Enter discount amount'),
                              onChanged: (value) {
                                setState(() {
                                  discount = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Add Discount', style: TextStyle(color: Colors.blueAccent)),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Charge Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to customer details and payment mode
                    // Navigator.push(
                    //   context,
                    //   // MaterialPageRoute(
                    //   //   builder: (context) =>
                    //   //       CustomerDetailsPage(
                    //   //     cart: widget.cart,
                    //   //     subtotal: grandTotal,
                    //   //   ),
                    //   // ),
                    // );
                  },
                  child: Text(
                    'CHARGE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
