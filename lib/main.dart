import 'package:flutter/material.dart';
import 'Screens/SplashScreen.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(


        ),


        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
            centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20)// Set drawer icon color globally
        ),
      ),
      home: SplashScreen(),
    );
  }
}
