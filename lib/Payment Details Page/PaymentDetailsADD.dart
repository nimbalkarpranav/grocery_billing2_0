import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../DataBase/database.dart';

class AddPaymentDetailsPage extends StatefulWidget {
  @override
  _AddPaymentDetailsPageState createState() => _AddPaymentDetailsPageState();
}

class _AddPaymentDetailsPageState extends State<AddPaymentDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false; // For loading state

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  Future<void> savePaymentDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      final paymentDetail = {
        'customer_id': int.parse(_customerIdController.text),
        'amount': double.parse(_amountController.text),
        'date': _dateController.text,
      };

      await DBHelper.instance.insertPaymentDetail(paymentDetail);

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment details added successfully!')),
      );

      Navigator.pop(context); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Payment Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _customerIdController,
                    labelText: 'Customer ID',
                    hintText: 'Enter the customer ID',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty ? 'Customer ID is required' : null,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: _amountController,
                    labelText: 'Amount',
                    hintText: 'Enter the payment amount',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value!.isEmpty ? 'Amount is required' : null,
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: _dateController,
                        labelText: 'Date',
                        hintText: 'Select a date',
                        suffixIcon: Icons.calendar_today,
                        validator: (value) =>
                        value!.isEmpty ? 'Date is required' : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: savePaymentDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Payment Details',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
