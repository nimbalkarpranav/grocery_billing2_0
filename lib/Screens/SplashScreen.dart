import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grocery_billing2_0/Screens/PinScreen.dart';
import 'package:grocery_billing2_0/Screens/profileScreen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool isLoggedIn = pref.getBool('isLoggedIn') ?? false;
    bool isProfileCompleted = pref.getBool('isProfileCompleted') ?? false; // ✅ Check Profile Completion

    await Future.delayed(Duration(seconds: 3)); // ✅ 3 sec delay

    if (!mounted) return;

    if (!isLoggedIn) {
      // ✅ First Time User -> Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else if (!isProfileCompleted) {
      // ✅ Login ke baad agar Profile Complete nahi -> Profile Setup Page dikhao
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile()), // 🆕 Profile Setup
      );
    } else {
      // ✅ Agar Profile Complete hai -> PinScreen dikhao
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PinScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Lottie.asset(
            'assets/Animation - 1739798362492.json',
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}
