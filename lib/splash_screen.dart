import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/log_in.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),() async{
      final prefs = await SharedPreferences.getInstance();
      bool onboardingDone = prefs.getBool('onboardingDone') ?? false;
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=> onboardingDone ? LogIn() : OnboardingScreen(),));
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1253AA),
              Color(0xff05243E)
            ]
          )
        ),
        child: Column(
          children: [
            SizedBox(height: 130,),
            Image.asset('assets/images/check.png'),
            SizedBox(height: 30,),
            Text("DO IT", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.white
            ),
            ),
            SizedBox(height: 280,),
            Text("v 1.0.0",style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),)
          ],
        ),)

      
    );
  }
}
