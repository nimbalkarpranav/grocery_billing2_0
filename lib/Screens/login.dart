import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Screens/profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CanW Grocery Delivery',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        LoginPage(),
        WelcomeBackPage(),
        CreateAccountPage(),
      ],
    );
  }
}

// ✅ Login Page with Authentication Logic
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoginMode = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // ✅ Check if user is already logged in
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isFirstLogin ? Profile() :  HomePage(),
        ),
      );
    }
  }

  // ✅ Handle Login / Registration Logic
  void loginOrRegister() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showErrorDialog("Please fill in all fields");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isLoginMode) {
      // ✅ Login: Check stored credentials
      String? storedUsername = prefs.getString('username');
      String? storedPassword = prefs.getString('password');

      if (username == storedUsername && password == storedPassword) {
        await prefs.setBool('isLoggedIn', true);
        navigateAfterLogin();
      } else {
        showErrorDialog("Invalid credentials");
      }
    } else {
      // ✅ Registration: Save new credentials
      await prefs.setString('username', username);
      await prefs.setString('password', password);
      await prefs.setBool('isFirstLogin', true);
      await prefs.setBool('isLoggedIn', true);

      showSuccessDialog();
    }
  }


  // ✅ Navigate after login based on first-time login
  void navigateAfterLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isFirstLogin ? Profile() : HomePage(),
      ),
    );
  }

  // ✅ Show Error Dialog
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
        ],
      ),
    );
  }

  // ✅ Show Success Dialog
  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Registration Successful"),
        content: Text("You can now log in."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isLoginMode = true;
              });
            },
            child: Text("Login Now"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 80, color: Colors.redAccent),
            SizedBox(height: 20),
            Text(
              isLoginMode ? 'Welcome Back' : 'Create an Account',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginOrRegister,
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              child: Text(isLoginMode ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLoginMode = !isLoginMode;
                });
              },
              child: Text(
                isLoginMode ? "Don't have an account? Register" : "Already have an account? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Welcome Back Page (For Returning Users)
class WelcomeBackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            TextButton(onPressed: () {}, child: Text('Forgot password?')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Log in')),
          ],
        ),
      ),
    );
  }
}

// ✅ Create Account Page (For New Users)
class CreateAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: 'Name')),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Sign up')),
          ],
        ),
      ),
    );
  }
}
