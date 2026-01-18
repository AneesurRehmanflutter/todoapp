import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController codeController = TextEditingController();
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Verify Account",style: TextStyle(color: Colors.white,fontSize: 30),),
                SizedBox(height: 50,),
                Container(height: 450,
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x66FFFFFF),
                      Color(0x19FFFFFF),
                    ]
                  )
                ),
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Text("DO IT", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),),
                    SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text("By verifying your account, you data will be secured and be default you are accepting our terms and policies",style: TextStyle(
                          color: Colors.white, fontSize: 16,
                        ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox( width: 250,
                        child: TextFormField(
                          controller: codeController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Verification Code",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      SizedBox(width: 250,
                        height: 50,
                        child: ElevatedButton(onPressed: (){

                        },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff0EA5E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              )

                            ),
                            child: Text("Verify",style: TextStyle(color: Colors.white),)),
                      ),
                    ],
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
