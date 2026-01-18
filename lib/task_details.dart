import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/bottomsheet_class.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model_class.dart';
class TaskDetails extends StatefulWidget {

  final Task task;
  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {

  late Task data;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    data=widget.task;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      backgroundColor: Color(0xff1253AA),
      leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:Icon(Icons.arrow_back_ios,color: Color(0xff63D9F3))),
      title: Text("Task Details",style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),),
      centerTitle: true,
    ),
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
        ) ,
          child:  Padding(
            padding: const EdgeInsets.only(left: 50),
            child: SingleChildScrollView(
              child: Column(
                    children: [

                      SizedBox(height: 160,),
                    Row(
                      children: [
                        Text(data.title, style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                     SizedBox(width: 20,),
                     IconButton(
                       icon:   Icon(Icons.edit_calendar,
                         color: Colors.white,size: 20,),
                       onPressed: () async{
                         final updated =
                    await showModalBottomSheet(
                         context: context,
                         builder: (context){
                           return BottomSheetClass(task: data,);
                         }
                         );
                    if(updated != null && updated == true){
                      try{
                        var doc = await FirebaseFirestore.instance
                            .collection("user")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("task")
                            .doc(data.docid)
                            .get();

                        if(doc.exists && doc.data() != null){
                          setState(() {
                            data= Task.fromJson(doc.data()!);
                          });
                        }
                      }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Failed to refresh task"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                     },
                     )
              
                      ],
                    ),
                    SizedBox(height: 5,),
              
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.white, size: 15,),SizedBox(width: 3,),
                        Text(data.date, style: TextStyle(color: Colors.white),),
                        Text("  |  ", style: TextStyle(color: Colors.white),),
                        Icon(Icons.access_time, color: Colors.white, size: 15,),SizedBox(width: 3,),
                        Text(data.time, style: TextStyle(color: Colors.white),),
                      ],
                    ),
                      SizedBox(height: 30,),
              
                      Row(
                        children: [
                          Container(
                            height: 1,
                            width: 250,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 60),
                            child: Text(data.description,
                              style: TextStyle(
                              color: Colors.white
                            ),),
                          ),
                        ),
                      ],
                    ),
                      SizedBox(height: 100,),
                      Row(
                        children: [
                          SizedBox( height: 61, width: 78,
                            child: Container( decoration: BoxDecoration(
                            boxShadow: [ BoxShadow(
                              color: Colors.white.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 0)
                            )]
                            ),
                              child: ElevatedButton(onPressed:()async {
                                try {
                                  await FirebaseFirestore.instance.collection(
                                      "user")
                                      .doc(FirebaseAuth.instance.currentUser!.uid)
                                      .collection("task")
                                      .doc(data.docid).
                                  update({"isCompleted": true});
                                  Navigator.pop(context);
                                }catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Failed to Update task. Please try again."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

                              },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff05243E),
              
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
              
                                )
                              ),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.lightGreenAccent,size: 15,),
                                      SizedBox(height: 5,),
                                      Text("Done", style: TextStyle(color: Colors.white,fontSize: 12), ),
                                    ],
                                  )
                              ),
                            ),
                          ),SizedBox(width: 10,),
                          SizedBox( height: 61, width: 78,
                            child: Container( decoration: BoxDecoration(
                                boxShadow: [ BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 0)
                                )]
                            ),
                              child: ElevatedButton(onPressed:() {
                               showDialog(context: context, builder: (context)
                               {
                                 return AlertDialog(
                                   title: Text("Delete"),
                                   icon: Icon(Icons.delete, color: Colors.red,),
                                   content: Text("Are you sure you want to Delete"),
                                   actions: [
                                     ElevatedButton(
                                         onPressed: () async{
                                           try {
                                          await FirebaseFirestore.instance.collection("user")
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .collection("task")
                                              .doc(data.docid).
                                          delete();
                                           Navigator.pop(context);
                                           Navigator.pop(context);
                                           }catch (e) {
                                             ScaffoldMessenger.of(context).showSnackBar(
                                               SnackBar(
                                                 content: Text("Failed to delete task. Please try again."),
                                                 backgroundColor: Colors.red,
                                               ),
                                             );
                                           }

                                 },
                                         child: Text("Yes")),
              
                                     ElevatedButton(onPressed: (){
                                       Navigator.pop(context);
                                     }, child: Text("No"))
              
                                   ],
                                 );
                               }
                               );
                               },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff05243E),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
              
                                      )
                                  ),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete_outlined, color: Colors.red,size: 15,),
                                      SizedBox(height: 5,),
                                      Text("Delete", style: TextStyle(color: Colors.white,fontSize: 10), ),
                                    ],
                                  )
                              ),
                            ),
                          ), SizedBox(width: 10,),
                          SizedBox( height: 61, width: 78,
                            child: Container( decoration: BoxDecoration(
                                boxShadow: [ BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 0)
                                )]
                            ),
                              child: ElevatedButton(onPressed:(){
                              },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff05243E),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
              
                                      )
                                  ),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.push_pin, color: Colors.yellow,size: 15,),
                                      SizedBox(height: 5,),
                                      Text("Pin", style: TextStyle(color: Colors.white,fontSize: 12), ),
                                    ],
                                  )
                              ),
                            ),
                          ),
              
                        ],
                      ),
                    ],
                  ),
            ),
          ),
      )
    );
  }
}
