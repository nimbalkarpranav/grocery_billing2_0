import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Home_screen/home_screen.dart';

class Pinscreen extends StatefulWidget {
  const Pinscreen({super.key});

  @override
  State<Pinscreen> createState() => _PinscreenState();
}

class _PinscreenState extends State<Pinscreen> {
  TextEditingController PinController = TextEditingController();
  get pinController => PinController.text.toString();

  String pin = "1234";

  void PinEnter() {
    if (pinController == pin) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent, Colors.blue], // Changed to green and blue
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: PinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Pin',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  PinEnter();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Changed button color to blue
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.blueAccent.shade700, // Changed shadow to blue
                  elevation: 8,
                ),
                child: Text(
                  "Enter",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
