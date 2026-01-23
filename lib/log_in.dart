import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/Sign_up.dart';
import 'package:todoapp/forgot_screen.dart';
import 'package:todoapp/main.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$');


  bool isLoading = false;
  bool isPasswordVisible = false;

@override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void loginNow() async{
    if(!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading=true;
    });
    try{
      UserCredential login = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text.trim());

      if(!mounted) return;

      if(login.user!.emailVerified){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("First verify your email")));
      }
    }
    catch(e){
      String message = 'Login Failed';
      if(e is FirebaseAuthException){
        if(e.code == 'user-not-found') message = 'no user found';
        if(e.code == 'wrong-password') message = 'Incorrect password';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar
        (content: Text(message)));
    }
    finally{
      setState(() {
        isLoading= false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:  SafeArea(
         child: Container(
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
           child:Form( key: _formKey,
             child: SingleChildScrollView(
               child: Padding(
                 padding: const EdgeInsets.all(25.0),
                 child: Column(
                   children: [
                     SizedBox(height: 50,),
                     Image(image: AssetImage("assets/images/check.png")),
                     SizedBox(height: 10,),
                     Row(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("Welcome Back to",style: TextStyle( fontSize: 25, color: Colors.white),),
                         Text(" DO IT",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.white),)
                       ],
                     ),
                     Text("Have an other productive day !", style: TextStyle(fontSize: 18,color: Colors.white),),
                     SizedBox(height: 30,),
                     SizedBox( width: 300,
                       child: TextFormField(
                         controller: emailController,
                         validator: (value){
                           if (value == null || value.isEmpty) {
                             return 'Email required';
                           }
                           if (!value.contains('@')) {
                             return 'Invalid email';
                           }
                           return null;
                         },
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
                         controller: passwordController,
                         obscureText: !isPasswordVisible,
                         validator: (value) {
                           if(value == null || value.isEmpty) return 'Password Required';

                           if(!passwordRegex.hasMatch(value)){
                             return 'Password must be 6+ chars, include upper, lower & number';
                           }
                           return null;
                         },
                         decoration: InputDecoration(
                             prefixIcon: Icon(Icons.lock),
                             filled: true,
                             fillColor: Colors.white,
                             hintText: "Password",
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                             ),
                           suffixIcon: IconButton(onPressed: (){
                             setState(() {
                               isPasswordVisible = !isPasswordVisible;
                             });
                           },
                               icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                           )
                         ),
                       ),
                     ),
                     SizedBox(height: 3,),
                     Align(alignment: Alignment.bottomRight,
                       child: TextButton(onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotScreen()));
                       },
                           child:Text("forget password?",style: TextStyle(
                             decoration: TextDecoration.underline,
                             decorationColor: Colors.white,
                             decorationThickness: 2,
                             color: Colors.white
                           ),
                           )),
                     ),
                     SizedBox(height: 20,),
                     SizedBox(width: 300,
                       child: ElevatedButton (
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Color(0xff0EA5E9)
                           ),
                           onPressed: isLoading ? null : loginNow,
                           child: isLoading ? SizedBox(
                             height: 22,
                             width: 22,
                             child: CircularProgressIndicator(
                               strokeWidth: 2,
                               color: Colors.white,
                             ),
                           ) : Text("Sign in",style: TextStyle(color: Colors.white),)),
                     ),
                     SizedBox(height: 10,),
                     Row( mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("Don't have an account ?",style: TextStyle(color: Colors.white),),
                       TextButton(onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                       },
                           child: Text("Sign up",style: TextStyle(color: Color(0xff63D9F3)))
                       )
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
           ),
         ),
       )
    );
  }
}
