import 'package:flutter/material.dart';

import 'EditPinDB/editpin.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  TextEditingController pinController = TextEditingController();
  String? pin;

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    pin = await DatabaseHelper.instance.getPin() ?? '1234'; // Default PIN if not set
    pinController.text = pin!;
    setState(() {});
  }

  void validatePin() {
    if (pinController.text == pin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid PIN"),
          content: Text("The PIN you entered is incorrect."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ok"),
            ),
          ],
        ),
      );
    }
  }

  Widget buildKeyboardButton(String value) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (value == "⌫") {
            if (pinController.text.isNotEmpty) {
              pinController.text = pinController.text
                  .substring(0, pinController.text.length - 1);
            }
          } else if (pinController.text.length < 4) {
            pinController.text += value;
          }
        },
        child: Container(
          margin: EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 60,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildKeyboard() {
    return Column(
      children: [
        Row(
          children: [
            buildKeyboardButton("1"),
            buildKeyboardButton("2"),
            buildKeyboardButton("3"),
          ],
        ),
        Row(
          children: [
            buildKeyboardButton("4"),
            buildKeyboardButton("5"),
            buildKeyboardButton("6"),
          ],
        ),
        Row(
          children: [
            buildKeyboardButton("7"),
            buildKeyboardButton("8"),
            buildKeyboardButton("9"),
          ],
        ),
        Row(
          children: [
            Spacer(),
            buildKeyboardButton("0"),
            buildKeyboardButton("⌫"),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueAccent,
              Colors.blue,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Enter Your PIN",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: pinController,
                    keyboardType: TextInputType.none,
                    obscureText: true,
                    maxLength: 4,
                    decoration: InputDecoration(
                      hintText: '----',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      counterText: "",
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
                    textAlign: TextAlign.center,
                    readOnly: true,
                  ),
                ],
              ),
              buildKeyboard(),
              ElevatedButton(
                onPressed: validatePin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade400,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                child: Text(
                  "Enter",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Secure PIN Authentication",
                  style: TextStyle(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
