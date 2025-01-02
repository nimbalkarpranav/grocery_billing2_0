import 'package:flutter/material.dart';
import '../home_screen.dart';
import 'editpin.dart';


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
    pin = await DatabaseHelper.instance.getPin();
    setState(() {});
  }

  void validatePin() async {
    if (pin == null) {
      // If no PIN is stored, prompt user to set a PIN
      await DatabaseHelper.instance.savePin(pinController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Redirect to HomePage
      );
    } else if (pinController.text == pin) {
      // If PIN matches, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // If PIN is incorrect
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid PIN"),
          content: Text("The PIN you entered is incorrect."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
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
          setState(() {}); // Refresh UI after tap
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
              color: Colors.blueAccent,
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter PIN", style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              TextField(
                controller: pinController,
                obscureText: true,
                maxLength: 4,
                decoration: InputDecoration(hintText: '----'),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              buildKeyboard(), // This is where the custom keyboard buttons are shown
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: validatePin,
                child: Text("Enter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
