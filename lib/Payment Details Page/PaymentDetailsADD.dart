import 'package:flutter/material.dart';
 // You need to import intl package for date formatting
import '../DataBase/database.dart';
import 'package:intl/intl.dart';

class AddPaymentDetailsPage extends StatefulWidget {
  @override
  _AddPaymentDetailsPageState createState() => _AddPaymentDetailsPageState();
}

class _AddPaymentDetailsPageState extends State<AddPaymentDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  // Set initial date to current date
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate); // Set default date
  }

  // Function to pick the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? _selectedDate;

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate); // Update the text controller
      });
    }
  }

  // Save payment details to the database
  Future<void> savePaymentDetails() async {
    if (_formKey.currentState!.validate()) {
      final paymentDetail = {
        'customer_id': int.parse(_customerIdController.text),
        'amount': double.parse(_amountController.text),
        'date': _dateController.text,
      };

      await DBHelper.instance.insertPaymentDetail(paymentDetail);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment details added successfully!')),
      );

      Navigator.pop(context); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Payment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _customerIdController,
                decoration: InputDecoration(labelText: 'Customer ID'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Customer ID is required' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Amount is required' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context), // Open date picker
                  ),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) => value!.isEmpty ? 'Date is required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: savePaymentDetails,
                child: Text('Save Payment Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
