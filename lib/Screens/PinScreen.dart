import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  List<String> pinInputs = ["", "", "", ""];
  final TextEditingController _pinController = TextEditingController();
  final int _pinLength = 4;

  @override
  void initState() {
    super.initState();
    checkStoredPin();
  }

  void checkStoredPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPin = prefs.getString('userPIN');
    print("Debug - Saved PIN: $savedPin");
  }

  void validatePin() async {
    String enteredPin = pinInputs.join();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPin = prefs.getString('userPIN');

    print("Entered PIN: $enteredPin");
    print("Saved PIN: $savedPin");

    if (savedPin != null && enteredPin == savedPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (enteredPin.length == 4) {
      setState(() {
        pinInputs = ["", "", "", ""];
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid PIN"),
          content: const Text("The PIN you entered is incorrect."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void updatePinInput(String value) {
    int index = pinInputs.indexOf("");
    if (value == "⌫") {
      if (index == -1) index = 4;
      if (index > 0) pinInputs[index - 1] = "";
    } else if (index < 4) {
      pinInputs[index] = value;
      if (index == 3) validatePin();
    }
    setState(() {});
  }

  Widget buildPinIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isFilled = pinInputs[index].isNotEmpty;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? Colors.blueAccent : Colors.grey.shade400,
          ),
        );
      }),
    );
  }

  Widget buildKeyboardButton(String value) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          updatePinInput(value);
        },
        child: Container(
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          height: 70,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 28,
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
            const Spacer(),
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
      backgroundColor: Colors.orange.shade200, // Adjust color based on the image
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Account', style: TextStyle(fontSize: 24, color: Colors.black)),
            SizedBox(height: 20),
            // Avatar above the PIN Entry
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Icon(Icons.face, size: 50, color: Colors.black), // replace with appropriate avatar
            ),
            buildPinIndicators(), // Display PIN dots
            SizedBox(height: 20),
            Text('Enter PIN', style: TextStyle(fontSize: 20, color: Colors.black)),
            Text('Please enter your PIN to proceed', style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 20),
            buildKeyboard(), // Numeric keypad
          ],
        ),
      ),
    );
  }
}
