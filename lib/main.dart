import 'package:flutter/material.dart';
import 'package:todoapp/homescreen.dart';
import 'package:todoapp/listscreen.dart';
import 'package:todoapp/log_in.dart';
import 'package:todoapp/profile.dart';
import 'package:todoapp/setting.dart';
import 'package:todoapp/calender.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/splash_screen.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
      url: 'https://rfxdfkiremxelfbpoyha.supabase.co',
      anonKey: 'sb_publishable_bX9dQGHjQGwvuEwtG6lvpw_-hlyOvbD');

  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> screens = [Homescreen(), Listscreen(), Calender(), Setting()
  ];
  int index=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
      children: screens ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xff05243E),
          // borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: BottomNavigationBar( type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xff63D9F3),
          unselectedItemColor: Colors.white,
          currentIndex : index,
          onTap: (newIndex){
            setState(() {
              index= newIndex;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, ), label: " ",),
            BottomNavigationBarItem(icon: Icon(Icons.list, ),  label: " "),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month, ), label: " "),
            BottomNavigationBarItem(icon: Icon(Icons.settings, ),  label: " ")
          ],
        ),
      ),
    );
  }
}
//Anees
