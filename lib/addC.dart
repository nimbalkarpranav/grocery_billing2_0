import 'package:flutter/material.dart';
import 'DataBase/database.dart';


class AddCategoryPage extends StatelessWidget {
  final TextEditingController categoryController = TextEditingController();

  void saveCategory(BuildContext context) async {
    if (categoryController.text.isNotEmpty) {
      final category = {'name': categoryController.text};
      await DBHelper.instance.insertCategory(category);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => saveCategory(context),
              child: Text('Save Category'),
            ),
          ],
        ),
      ),
    );
  }
}
