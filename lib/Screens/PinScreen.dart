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
      children: List.generate(_pinLength, (index) {
        bool isFilled = pinInputs[index].isNotEmpty;
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
            color: isFilled ? Colors.blueAccent : Colors.grey.shade400,
          ),
        );
      }),
    );
  }

  Widget buildKeyboardButton(String value) {
    return Expanded(
      child: GestureDetector(
        onTap: () => updatePinInput(value),
        child: Container(
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Colors.black26, Colors.grey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          height: 70,
          width: 70,
          child: value == "⌫"
              ? Icon(Icons.backspace, color: Colors.white, size: 28)
              : Text(
            value,
            style: TextStyle(
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
    List<String> keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "⌫"];
    return Column(
      children: List.generate(4, (rowIndex) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (colIndex) {
            int keyIndex = rowIndex * 3 + colIndex;
            return keys[keyIndex] == ""
                ? const Spacer()
                : buildKeyboardButton(keys[keyIndex]);
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enter PIN',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(width: 24), // Placeholder for alignment
                  ],
                ),
              ),

              // User Info
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage('https://placehold.co/100x100'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Please enter your PIN to proceed',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              // PIN Indicators
              buildPinIndicators(),
              SizedBox(height: 20),

              // Keyboard
              buildKeyboard(),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
