import 'package:flutter/material.dart';
import '../DataBase/database.dart';
import 'PaymentDetailsADD.dart';

class PaymentDetailsPage extends StatefulWidget {
  @override
  _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  List<Map<String, dynamic>> paymentDetails = [];

  @override
  void initState() {
    super.initState();
    fetchPaymentDetails();
  }

  Future<void> fetchPaymentDetails() async {
    final data = await DBHelper.instance.fetchPaymentDetails();
    setState(() {
      paymentDetails = data;
    });
  }

  Future<void> deletePaymentDetail(int id) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Payment Detail'),
        content: Text('Are you sure you want to delete this payment detail?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await DBHelper.instance.deletePaymentDetail(id);
      fetchPaymentDetails(); // Refresh list
    }
  }

  Future<void> updatePaymentDetail(Map<String, dynamic> detail) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        final amountController =
        TextEditingController(text: detail['amount'].toString());
        final dateController = TextEditingController(text: detail['date']);

        return AlertDialog(
          title: Text('Update Payment Detail'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, {
                  'id': detail['id'],
                  'customer_id': detail['customer_id'],
                  'amount': double.parse(amountController.text),
                  'date': dateController.text,
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await DBHelper.instance.updatePaymentDetail(result);
      fetchPaymentDetails(); // Refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPaymentDetailsPage(),
                ),
              ).then((_) => fetchPaymentDetails());
            },
          ),
        ],
      ),
      body: paymentDetails.isEmpty
          ? Center(child: Text('No payment details found.'))
          : ListView.builder(
        itemCount: paymentDetails.length,
        itemBuilder: (context, index) {
          final detail = paymentDetails[index];
          return GestureDetector(
            onLongPress: () => updatePaymentDetail(detail), // Long press to update
            child: ListTile(
              title: Text('Customer ID: ${detail['customer_id']}'),
              subtitle: Text('Amount: ${detail['amount']} \nDate: ${detail['date']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.edit, color: Colors.blue),
                  //   onPressed: () => updatePaymentDetail(detail),
                  // ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deletePaymentDetail(detail['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
