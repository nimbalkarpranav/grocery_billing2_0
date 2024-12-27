import 'package:flutter/material.dart';

import '../DataBase/database.dart';


void main(){
  runApp(Addcustomer());
}
class Addcustomer extends StatelessWidget {
  final TextEditingController categoryController = TextEditingController();

  void saveCastamur(BuildContext context) async {
    if (categoryController.text.isNotEmpty) {
      final castamur = {'name': categoryController.text};
      await DBHelper.instance.insertCastamur(castamur);
      Navigator.pop(context );
    }
    else{
      print("NOT ADD castamur");
    }
  }

  @override
  Widget build(BuildContext context) {
    return
     MaterialApp(
    home:
      Scaffold(
      appBar: AppBar(title: Text(' Add  Category')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category  '),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => saveCastamur(context),
              child: Text('Save Category'),
            ),
          ],
        ),
      ),
      )
    );
  }
}
