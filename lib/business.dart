import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Business extends StatefulWidget {
  const Business({super.key});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Image.file(File(_imagePath!));

  }
  String? _imagePath;
  Future<void> _pickImage() async {
    print("get1");
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String newPath = '${directory.path}/${pickedFile.name}';
      final File file = File(pickedFile.path);

      await file.copy(newPath);

      setState(() {
        _imagePath = newPath;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController bName = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title:Text("Business Profile "),
        centerTitle: true,
        actions: <Widget>[
          IconButton(onPressed: (){



          }, icon: Icon(Icons.edit))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Text("Business Image ",style: TextStyle(fontSize:21,color: Colors.black,fontWeight:FontWeight.bold),),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  height: 140,
                  width: 300,
                  color: Colors.black,
                  child:_imagePath == null ? Padding(
                    padding: const EdgeInsets.all(33.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      maxRadius: 33,

                      child: IconButton(onPressed:(){
                        _pickImage();
                        print("pressed");
                      }, icon: Icon(CupertinoIcons.camera,size: 44,color: Colors.white,)),
                    ),
                  ): Image.file(File(_imagePath!)),

                ),

              ],
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: bName,

                decoration: InputDecoration(
                  hintText: "Name ...",
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),

                    )
                ),

              ),
            )
          ],
        ),
      ),

    );
  }
}
