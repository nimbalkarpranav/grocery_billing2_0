import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editprof extends StatefulWidget {
  const Editprof({super.key});

  @override
  State<Editprof> createState() => _EditprofState();
}

class _EditprofState extends State<Editprof> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile "),
        centerTitle:  true,

      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController ,
              decoration: InputDecoration(
                label: Text("Name"),
                suffixIcon: Icon(Icons.person),
                // hintText:"Name" ,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7)

                )
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Name cannot be empty")),
                );
                return;
              }
              var prefs = await SharedPreferences.getInstance();
              await prefs.setString('name', name);
              Navigator.pop(context, name); // Pass the updated name back to Profile
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
            ),
          ),

          ElevatedButton(onPressed: (){


          }, child: Text("Change Pin",style: TextStyle(color: Colors.white),),style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)
          ),)
        ],
      )

    );
  }
}
