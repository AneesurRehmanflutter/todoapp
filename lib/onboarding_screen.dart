import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:todoapp/log_in.dart';
import 'package:todoapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
        child: IntroductionScreen(
          globalBackgroundColor: Colors.transparent,
          pages: [
            PageViewModel(
              decoration: PageDecoration(imageFlex: 2),
              image: Image.asset('assets/images/1st screen image.png'),
              titleWidget: Padding(
                padding: const EdgeInsets.all(10.10),
                child: Text("Plan your tasks to do, that way you’ll stay organized and you won’t skip any",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
              bodyWidget: Text(" ")
            ),
            PageViewModel(
                decoration: PageDecoration(imageFlex: 2),
                image: Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Image.asset('assets/images/2nd screen image.png'),
                ),
                titleWidget: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("Make a full schedule for the whole week and stay organized and productive all days",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
                bodyWidget: Text(" ")
            ),
            PageViewModel(
                decoration: PageDecoration(imageFlex: 2),
                image: Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Image.asset('assets/images/3rd screen image.png'),
                ),
                titleWidget: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("create a team task, invite people and manage your work together",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
                bodyWidget: Text(" ")
            ),
            PageViewModel(
                decoration: PageDecoration(imageFlex: 2),
                image: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Image.asset('assets/images/4th screen image.png'),
                ),
                titleWidget: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("create a team task, invite people and manage your work together",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
                bodyWidget: Text(" ")
            )
          ],

          next: Image.asset("assets/images/next button.png"),
          done: Image.asset("assets/images/done button.png"),
          dotsDecorator: DotsDecorator(
            size: Size(15.0, 8.0),
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ) ,
            activeSize:const Size(30.0, 8.0),
            activeColor: Colors.white,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            spacing: EdgeInsets.symmetric(horizontal: 2,),

          ),
          onDone: () async{
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('onboardingDone', true);

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LogIn()));
          },
        ),
      ),
    );
  }
}
