import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/DataBase/database.dart';
import 'package:grocery_billing2_0/Screens/profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PinScreen.dart';
import 'home_screen.dart'; // Or any next screen after login
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoginMode = true;
  void initState() {
    super.initState();
    checkLoginStatus();
  }



  void navigateAfterLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFirstLogin = pref.getBool('isFirstLogin') ?? true;
    bool isProfileCompleted = pref.getBool('isProfileCompleted') ?? false;

    if (isFirstLogin || !isProfileCompleted) {
      await pref.setBool('isFirstLogin', false); // First login complete mark karo
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PinScreen()),
      );
    }
  }


  void checkLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isLoggedIn = pref.getBool('isLoggedIn') ?? false;
    bool isFirstLogin = pref.getBool('isFirstLogin') ?? true;

    if (isLoggedIn) {
      if (isFirstLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // First login pe profile page bhej
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PinScreen()), // Baad me PIN screen pe bhej
        );
      }
    }
  }


  void loginOrRegister() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please Fill Up All Fields")),
      );
      return;
    }

    if (isLoginMode) {
      // **Login Mode**
      var user = await DBHelper.instance.loginUser(username, password);
      if (user != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setBool('isLoggedIn', true);
        navigateAfterLogin(); // ✅ Fix: Navigate according to Profile Completion
      }else {
        _showDialog('Invalid credentials');
      }
    } else {
      // **Register Mode**
      bool userExists = await DBHelper.instance.userExists(username);

      if (userExists) {
        _showDialog('User already exists. Please login.');
      } else {
        await DBHelper.instance.registerUser(username, password);
        _showRegistrationDialog();
        setState(() {
          isLoginMode = true; // Registration ke baad login mode pe wapas aayega
        });
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
  void _showRegistrationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Registration Successful"),
        content: Text("Do you want to login now?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // ❌ Close only
            child: Text("Later"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isLoginMode = true;
              });
            },
            child: Text("Login Now", style: TextStyle(color: Colors.blue)),
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
