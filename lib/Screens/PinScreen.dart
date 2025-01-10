import 'package:flutter/material.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  final String savedPin;

  const PinScreen({Key? key, required this.savedPin}) : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  List<String> pinInputs = ["", "", "", ""];
  String? pin;

  @override
  void initState() {
    super.initState();
    pin = widget.savedPin; // Initialize with the provided saved PIN
  }

  void validatePin() {
    String enteredPin = pinInputs.join();
    if (pin != null && enteredPin == pin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (enteredPin.length == 4) {
      // Clear the inputs and show an error if PIN is incorrect
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
      if (index == -1) index = 4; // All boxes filled, remove last digit
      if (index > 0) pinInputs[index - 1] = "";
    } else if (index < 4) {
      pinInputs[index] = value;
      if (index == 3) validatePin(); // Validate when all 4 digits are entered
    }
    setState(() {});
  }

  Widget buildPinBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 50,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blueAccent, width: 2),
          ),
          child: Text(
            pinInputs[index],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
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
          margin: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
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
            const Spacer(), // To center-align the "0" button
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
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter PIN",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              buildPinBoxes(), // Display 4 PIN input boxes
              const SizedBox(height: 20),
              buildKeyboard(), // Custom keyboard buttons
            ],
          ),
        ),
      ),
    );
  }
}
