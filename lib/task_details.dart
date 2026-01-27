import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todoapp/bottomsheet_class.dart';
import 'package:todoapp/getx_controller_class.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model_class.dart';


class TaskDetails extends StatefulWidget {

  final Task task;
  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  getxcontroller controller = Get.find<getxcontroller>();

  late Rx<Task> data;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.task.obs;
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
              child: Obx(() {
                final task = data.value;
                return Column(
                  children: [

                    SizedBox(height: 160,),
                    Row(
                      children: [
                        Text(task.title, style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                        SizedBox(width: 20,),
                        IconButton(
                          icon: Icon(Icons.edit_calendar,
                            color: Colors.white, size: 20,),
                          onPressed: () async {
                            final updated =
                            await showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BottomSheetClass(task: task,);
                                }
                            );
                            if (updated == true) {
                              Task? refreshed = await controller.updateTask(
                                  task.docid);
                              if (refreshed != null) {
                                data.value = refreshed;
                              }
                            }
                          },
                        )

                      ],
                    ),
                    SizedBox(height: 5,),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month, color: Colors.white, size: 15,),
                        SizedBox(width: 3,),
                        Text(task.date, style: TextStyle(color: Colors.white),),
                        Text("  |  ", style: TextStyle(color: Colors.white),),
                        Icon(Icons.access_time, color: Colors.white, size: 15,),
                        SizedBox(width: 3,),
                        Text(task.time, style: TextStyle(color: Colors.white),),
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
                            child: Text(task.description,
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
                        SizedBox(height: 61, width: 78,
                          child: Container(decoration: BoxDecoration(
                              boxShadow: [ BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)
                              )
                              ]
                          ),
                            child: ElevatedButton(onPressed: () {
                              controller.doneTask(task.docid);

                              Get.back();
                            },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff05243E),

                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)

                                    )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle,
                                      color: Colors.lightGreenAccent,
                                      size: 15,),
                                    SizedBox(height: 5,),
                                    Text("Done", style: TextStyle(
                                        color: Colors.white, fontSize: 12),),
                                  ],
                                )
                            ),
                          ),
                        ), SizedBox(width: 10,),
                        SizedBox(height: 61, width: 78,
                          child: Container(decoration: BoxDecoration(
                              boxShadow: [ BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)
                              )
                              ]
                          ),
                            child: ElevatedButton(onPressed: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text("Delete"),
                                  icon: Icon(Icons.delete, color: Colors.red,),
                                  content: Text(
                                      "Are you sure you want to Delete"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          controller.deleteTask(task.docid);
                                          Get.back();
                                          Get.back();
                                        },
                                        child: Text("Yes")),

                                    ElevatedButton(onPressed: () {
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete_outlined, color: Colors.red,
                                      size: 15,),
                                    SizedBox(height: 5,),
                                    Text("Delete", style: TextStyle(
                                        color: Colors.white, fontSize: 10),),
                                  ],
                                )
                            ),
                          ),
                        ), SizedBox(width: 10,),
                        SizedBox(height: 61, width: 78,
                          child: Container(decoration: BoxDecoration(
                              boxShadow: [ BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)
                              )
                              ]
                          ),
                            child: ElevatedButton(onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff05243E),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)

                                    )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.push_pin, color: Colors.yellow,
                                      size: 15,),
                                    SizedBox(height: 5,),
                                    Text("Pin", style: TextStyle(
                                        color: Colors.white, fontSize: 12),),
                                  ],
                                )
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                );
              }
              )
            ),
          ),
      )
    );
  }
}
