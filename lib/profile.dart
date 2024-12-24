import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page "),
        centerTitle: true,
        actions: <Widget>[
          IconButton(onPressed: (){}, icon: Icon(Icons.edit)),

        ],

      ),
      body: Container(
        child: Row(
          children: [
            Center(
              child: Container(
                child: Icon(Icons.person),

              ),
            )
          ],
        ),
      ),


    );
  }
}
