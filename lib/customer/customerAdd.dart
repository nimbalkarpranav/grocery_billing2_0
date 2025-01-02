import 'package:flutter/material.dart';
import '../DataBase/database.dart';

class AddCustomerPage extends StatefulWidget {
  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String? _email;

  Future<void> _addCustomer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DBHelper.instance.insertCustomer({
        'name': _name,
        'phone': _phone,
        'email': _email,
      });
      Navigator.pop(context, true); // Notify success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a phone number' : null,
                onSaved: (value) => _phone = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email (Optional)'),
                onSaved: (value) => _email = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCustomer,
                child: Text('Add Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
