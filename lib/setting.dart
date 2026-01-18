import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/log_in.dart';
import 'package:todoapp/profile.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1253AA),
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:Icon(Icons.arrow_back_ios,color: Color(0xff63D9F3))),
        title: Text("Settings",style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1253AA), Color(0xff05243E)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [Padding(padding: EdgeInsets.all(80)),
                Row(
                  children: [
                    Icon(Icons.person_pin,color: Colors.white,size: 30),

                    SizedBox(width: 15),
                    Text("Profile",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: ()async{
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Profile()),
                        );

                        if (result == true) {
                          setState(() {
                          });
                        }
                      },
                      icon: Icon(Icons.arrow_forward_ios,color: Color(0xff86DAED)),
                    )
                  ],
                ),
                Divider(color: Colors.blueGrey),
                Row(
                  children: [
                    Icon(Icons.messenger_rounded,color: Colors.white,size: 30),
                    SizedBox(width: 15),
                    Text("Conversations",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.arrow_forward_ios,color: Color(0xff86DAED)),
                    )
                  ],
                ),
                Divider(color: Colors.blueGrey),
                Row(
                  children: [
                    Icon(Icons.lightbulb_circle,color: Colors.white,size: 30),
                    SizedBox(width: 15),
                    Text("Projects",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.arrow_forward_ios,color: Color(0xff86DAED)),
                    )
                  ],
                ),
                Divider(color: Colors.blueGrey),
                Row(
                  children: [
                    Icon(Icons.library_books,color: Colors.white,size: 30),
                    SizedBox(width: 15),
                    Text("Terms and Policies",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.arrow_forward_ios,color: Color(0xff86DAED)),
                    )
                  ],
                ),
                Divider(color: Colors.blueGrey),
                SizedBox(height: 80),
                ],
            ),
          ),
        ),
      ),
    );
  }
}