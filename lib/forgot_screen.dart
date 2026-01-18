import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/log_in.dart';
class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {

  final TextEditingController emailController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Color(0xff1253AA),
      leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:Icon(Icons.arrow_back_ios,color: Color(0xff63D9F3))),
      title: Text("Forgot Password",style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),),
      centerTitle: true,
    ),
        body: Container(height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient (
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:[
                    Color(0xff1253AA),
                    Color(0xff05243E)
                  ])
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [ SizedBox(height: 30,),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: () async{
                     try {
                       await FirebaseAuth.instance.sendPasswordResetEmail(
                           email: emailController.text.toString());
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogIn()));

                     } catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar
                       (content: Text(e.toString())));
                     }
                       },
                        child: Text("Send email"))
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
