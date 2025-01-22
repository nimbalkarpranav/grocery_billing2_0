import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Screens/business.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PinScreen.dart';
import 'editpin.dart';
import 'home_screen.dart'; // Or any next screen after login

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoginMode = true;
  void navigateAfterLogin() async {
    bool firstLogin = await DatabaseHelper.instance.isFirstLogin();
    if (firstLogin) {
      await DatabaseHelper.instance. setFirstLoginCompleted();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PinScreen(savedPin: "1234")),
      );

    }
  }

  void loginOrRegister() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    if(username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Fill Up All Fields"),
          )
      );


    }
     else {
      // Register new user
      await DatabaseHelper.instance.registerUser(username, password);
      _showDialog('User registered successfully. Please login.');
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context,) => BusinessEdit(),));

    }
    if (isLoginMode) {
      // Attempt login
      var user = await DatabaseHelper.instance.loginUser(username, password);
      if (user != null) {
        // Save login status
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true); // Mark as logged in

        // Navigate to PIN screen or HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PinScreen(savedPin: '1234',)), // or HomePage()
        );
      } else {
        _showDialog('Invalid credentials');
      }
    }

  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginMode ? 'Login Page' : 'Register Page',style: TextStyle(color: Colors.white),),
        centerTitle: true ,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 30),
                Text(
                  isLoginMode ? 'Welcome Back' : 'Create an Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: loginOrRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    isLoginMode ? 'Login' : 'Register',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginMode = !isLoginMode;
                    });
                  },
                  child: Text(
                    isLoginMode
                        ? "Don't have an account? Register"
                        : "Already have an account? Login",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
