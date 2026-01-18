import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/log_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}


class _SignUpState extends State<SignUp> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final RegExp emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$');
  final RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');

  FirebaseAuth auth = FirebaseAuth.instance;

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signupNow() async{
    if(!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading= true;
    });
    try {
     UserCredential signup= await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
     await signup.user!.updateDisplayName(nameController.text);

     FirebaseFirestore.instance.collection("user").
     doc(signup.user!.uid).set({
       "email":emailController.text.trim(),
       "name":nameController.text.trim()
     });
     await signup.user!.sendEmailVerification();

    showDialog(
       context: context,
       barrierDismissible: false,
       builder: (context) =>
           AlertDialog(
         title: Text("Account Created!"),
         content: Text(
             "Your account has been created successfully.Please verify your email by clicking the link sent to your email."),
           ),
     );
   await Future.delayed(Duration(seconds: 3));{
      if(mounted){
        Navigator.pop(context);
      Navigator.pushReplacement((context),
      MaterialPageRoute(builder: (context) => LogIn()));
      }
    }
    }on FirebaseAuthException catch(e){
      String message = 'Signup Failed';
      if(e.code == 'email-already-in-use') message = "email already exists";

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (content: Text(message)));
      }


    } catch(_){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar
        (content: Text("Something went wrong")));
    } finally{
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Container(
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
          child:Form(key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Image(image: AssetImage("assets/images/check.png")),
                  SizedBox(height: 10,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome Back to ",style: TextStyle( fontSize: 25, color: Colors.white),),
                      Text(" DO IT",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.white),)
                    ],
                  ),
                  Text("Create an account and Join us now!", style: TextStyle(fontSize: 18,color: Colors.white),),
                  SizedBox(height: 30,),
              
                  SizedBox( width: 300,
                    child: TextFormField(
                      validator: (value){
                        if(value == null || value.trim().isEmpty){
                          return "Please enter your full name";
                        }
                        return null;
                      },
              
                      controller: nameController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.people),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Full Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  SizedBox( width: 300,
                    child: TextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please enter email";
                        }
                        if(!emailRegex.hasMatch(value)){
                          return "Enter valid email";
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "E mail",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  SizedBox( width: 300,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a Password";
                        }
                        if(!passwordRegex.hasMatch(value)){
                          return "Enter correct password";
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        suffixIcon:
                        IconButton(onPressed: (){
                         setState(() {
                           isPasswordVisible = !isPasswordVisible;
                         });
                        },
                            icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off))

                      ),
                    ),
                  ),
              
                  SizedBox(height: 20,),
                  SizedBox(width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0EA5E9)),
                      onPressed: isLoading ? null : signupNow,

                        child: isLoading ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                        : Text("Sign up",style: TextStyle(color: Colors.white),)),
                  ),
                  SizedBox(height: 10,),
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",style: TextStyle(color: Colors.white),),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> LogIn()));
                      },
                          child: Text("Sign in",style: TextStyle(color: Color(0xff63D9F3)),))
                    ],
                  ),
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign in with:", style: TextStyle(color: Colors.white),),
                      SizedBox(width: 35,),
                      Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset('assets/images/apple.png',)
                      ),
                      SizedBox(width: 15,),
                      Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset('assets/images/google.png',)
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )

    );
  }
}
