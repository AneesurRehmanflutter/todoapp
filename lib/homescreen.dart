import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/getx_controller_class.dart';
import 'package:todoapp/task_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/model_class.dart';
import 'package:get/get.dart';
import 'getx_controller_class.dart';

class Homescreen extends StatefulWidget {

  Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  getxcontroller controller = Get.put(getxcontroller());

  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(height: 20,),

                Obx(() {
                  if (controller.isProfileloading.value) {
                  return Center(child: CircularProgressIndicator(color: Colors.white));
                }
                      return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xff05243E),
                      backgroundImage: controller.profileImageUrl.value != null
                          ? NetworkImage(controller.profileImageUrl.value!)
                          : null,
                      child: controller.profileImageUrl.value == null
                          ? const Icon(Icons.person, size: 30, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      controller.userName.value ?? "User name",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                     controller.userEmail.value ?? "email@gmail.com",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.notification_add, color: Colors.white),
                  );
                }),
                SizedBox(height: 20,),
                Text("Group Tasks", style: TextStyle(color: Colors.white,fontSize: 15),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Container(
                      height: 80,
                      width: 130,
                      color: Colors.white,
                      child: Center(child: Text("Design Meeting")),
                    ), SizedBox(width: 10,),
                    Container(
                      height: 80,
                      width: 130,
                      color: Colors.white,
                      child: Center(child: Text("Project Meeting")),
                    ),
                  ],
                ),
                SizedBox(height: 12,),

                SizedBox(height: 10,),
                Expanded(
                  child: Obx((){
                        if (controller.isloading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (controller.allTask.isEmpty) {
                          return Center(
                            child: Text(
                              "No Tasks Found",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        //
                        // List<Task> alltask =snapshot.data!.docs.map((doc){
                        //   return Task.fromJson(doc.data() as Map<String, dynamic>);
                        // }).toList();
                        //
                        // List<Task> incompletetask = alltask.where((task) => task.isCompleted == false).toList();
                        // List<Task> completetask = alltask.where((task) => task.isCompleted == true).toList();

                        return SingleChildScrollView(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("InCompleted Task",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                              ),
                              if(controller.incompleteTask.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text("No InCompleted Task",style: TextStyle(color: Colors.green,fontSize: 15),),)
                              else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.incompleteTask.length,
                                itemBuilder: (context, int index){
                                  Task model =controller.incompleteTask[index];
                                  return Card(
                                      child: ListTile(
                                        title:Text(model.title),
                                          trailing: IconButton(
                                            icon: Icon(Icons.arrow_forward_ios),
                                            onPressed: (){
                                             Get.to(TaskDetails(task: model));
                                              },
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text(model.time),
                                              Text("  |  "),
                                              Text(model.date)
                                            ],
                                          ),
                                      )
                                  );
                                },
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("Completed Task",style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.bold),),
                              ),
                              if(controller.completeTask.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text("No Completed Task",style: TextStyle(color: Colors.green,fontSize: 15),),)
                              else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.completeTask.length,
                                itemBuilder: (context, int index){
                                  Task model =controller.completeTask[index];
                                  return Card(
                                      child: ListTile(
                                        title:Text(model.title),
                                        trailing: IconButton(
                                          icon: Icon(Icons.arrow_forward_ios),
                                          onPressed: (){
                                          Get.to(TaskDetails(task: model));

                                          },
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Text(model.time),
                                            Text("  |  "),
                                            Text(model.date)
                                          ],
                                        ),
                                      )
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      }
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
