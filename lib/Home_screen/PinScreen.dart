import 'package:flutter/material.dart';

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
    } else {
      // You can show an alert or a message if the PIN is incorrect
      print("Incorrect PIN");
    }
  }

  void handleButtonPress(String value) {
    setState(() {
      if (value == 'Erase') {
        if (PinController.text.isNotEmpty) {
          PinController.text = PinController.text.substring(0, PinController.text.length - 1);
        }
      } else if (value == 'Done') {
        PinEnter();
      } else {
        PinController.text += value;
      }
    });
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
            colors: [Colors.blueAccent, Colors.blue],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display the current pin
              TextField(
                controller: PinController,
                keyboardType: TextInputType.none, // Disable the system keyboard
                decoration: InputDecoration(
                  hintText: 'Enter Pin',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withBlue(3),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
                readOnly: true, // Make it read-only as the custom keyboard will be used
              ),
              SizedBox(height: 20),

              // Custom keyboard layout
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  String buttonText;

                  if (index < 9) {
                    buttonText = (index + 1).toString(); // Buttons 1 to 9
                  } else if (index == 9) {
                    buttonText = '0'; // Button 0
                  } else if (index == 10) {
                    buttonText = 'Done'; // Done button
                  } else {
                    buttonText = 'Erase'; // Erase button
                  }

                  return ElevatedButton(
                    onPressed: () => handleButtonPress(buttonText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade700,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduced padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.blue.shade700,
                      elevation: 8,
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Adjusted font size
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
