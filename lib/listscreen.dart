import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/calender.dart';
import 'package:todoapp/getx_controller_class.dart';
import 'package:todoapp/homescreen.dart';
import 'package:todoapp/model_class.dart';
import 'package:todoapp/setting.dart';
import 'package:todoapp/task_details.dart';

import 'bottomsheet_class.dart';

class Listscreen extends StatefulWidget {
  const Listscreen({super.key});

  @override
  State<Listscreen> createState() => _ListScreenState();
}
class _ListScreenState extends State<Listscreen> {
  final TextEditingController searchController= TextEditingController();
  final _formkey = GlobalKey<FormState>();
  getxcontroller controller = Get.put(getxcontroller());

  String searchText= "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
              height: double.infinity,
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

                  child: Column(
                    children: [SizedBox(height: 30,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                       //   mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex :2,
                              child: TextField(
                                controller: searchController,
                                style: TextStyle(
                                    color: Colors.white),
                                decoration: InputDecoration(
                                    fillColor: Color(0xff102D53), filled: true,
                                hintText: "Search by task title ",hintStyle: TextStyle(color: Colors.white,fontSize: 14),
                              suffixIcon: Icon(Icons.search),
                                    enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                              )
                                ),
                                onChanged: (value){
                                  controller.searchQuery.value =value;
                                  controller.search.assignAll(
                                      controller.allTask.where((task) => task.title.toLowerCase().contains(value.toLowerCase())).toList());
                                },
                              ),
                            ), SizedBox(width: 20,),
                            SizedBox(width: 110,height: 45,
                              child: TextField(style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(fillColor: Color(0xff102D53), filled: true,
                                  hintText: "Sort by",hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                                prefixIcon: Icon(Icons.sort),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                                )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  Expanded(
                   child: Obx(() {
                      if (controller.isloading.value) {
                    return Center(child: CircularProgressIndicator(color: Colors.white,));
                      }
                      if (controller.allTask.isEmpty) {
                    return Center(child: Text("no data found", style: TextStyle(color: Colors.white),));
                      }
                      //
                      // final alltask = snapshot.data!.docs;
                      //
                      // final filteredtask = alltask.where((doc){
                      //   final title= (doc.data() as Map<String, dynamic>)["title"].toString().toLowerCase();
                      //   return title.contains(searchText);
                      // }).toList();

                      return ListView.builder(
                    itemCount: controller.search.length,
                    itemBuilder: (context, int index) {
                      final model = controller.search[index];
                      return Padding(
                        padding:  EdgeInsets.only(top: 20),
                        child: Center(
                          child: SizedBox(
                            width: 320,
                            child: Card(
                              child: ListTile(
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: (){
                                   Get.to(TaskDetails(task: model));

                                  },
                                ),
                                title: Text(model.title),
                                subtitle: Row(
                                  children: [
                                    Text(model.time),
                                    Text("  |  "),
                                    Text(model.date)
                                  ],
                                ),

                              ),
                            ),
                          ),
                        ),
                      );
                    },
                      );
                    }
                    ),
                  ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 20),
                        child: Align(alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            onPressed: () async{
                            await showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return BottomSheetClass();

                                    //Container(
                                  //   height: 460,
                                  //   width: double.infinity,
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius: BorderRadius.only(
                                  //           topRight: Radius.circular(20),
                                  //           topLeft: Radius.circular(20))
                                  //   ),
                                  //   child:BottomSheetClass()
                                  //   Form(key: formkey,
                                  //     child: Column(
                                  //       children: [
                                  //         SizedBox(height: 20,),
                                  //         SizedBox(width: 300,
                                  //           child: TextFormField(
                                  //               controller: titleController,
                                  //               style: TextStyle(color: Colors.white),
                                  //               decoration: InputDecoration(
                                  //                   hintText: "Title",
                                  //                   hintStyle: TextStyle(
                                  //                       color: Colors.white),
                                  //                   fillColor: Color(0xFF05243E),
                                  //                   filled: true,
                                  //                   prefixIcon: Icon(Icons.task_alt,
                                  //                     color: Colors.white,),
                                  //                   enabledBorder: OutlineInputBorder(
                                  //                       borderRadius: BorderRadius
                                  //                           .circular(10)
                                  //                   )
                                  //               ),
                                  //           ),
                                  //         ),
                                  //         SizedBox(height: 30,),
                                  //         SizedBox(width: 300,
                                  //           child: TextFormField(maxLines: 5,
                                  //               controller: descriptionController,
                                  //               style: TextStyle(color: Colors.white),
                                  //               decoration: InputDecoration(
                                  //                   hintText: "Description",
                                  //                   hintStyle: TextStyle(
                                  //                       color: Colors.white),
                                  //                   fillColor: Color(0xFF05243E),
                                  //                   filled: true,
                                  //
                                  //                   prefixIcon: Padding(
                                  //                     padding: const EdgeInsets.only(
                                  //                         bottom: 100),
                                  //                     child: Icon(
                                  //                       Icons.density_small_sharp,
                                  //                       color: Colors.white,),
                                  //                   ),
                                  //
                                  //
                                  //                   enabledBorder: OutlineInputBorder(
                                  //                       borderRadius: BorderRadius.circular(10)
                                  //                   )
                                  //               )
                                  //           ),
                                  //         ), SizedBox(height: 20,),
                                  //         Row(
                                  //           mainAxisAlignment: MainAxisAlignment.center,
                                  //           children: [
                                  //             SizedBox(width: 140,
                                  //               child: TextFormField(
                                  //                   controller: dateController,
                                  //                   style: TextStyle(
                                  //                       color: Colors.white),
                                  //                   decoration: InputDecoration(
                                  //                       hintText: "Date",
                                  //                       hintStyle: TextStyle(
                                  //                           color: Colors.white),
                                  //                       fillColor: Color(0xFF05243E),
                                  //                       filled: true,
                                  //                       prefixIcon: Icon(
                                  //                         Icons.date_range,
                                  //                         color: Colors.white,),
                                  //                       enabledBorder: OutlineInputBorder(
                                  //                           borderRadius: BorderRadius
                                  //                               .circular(10)
                                  //                       )
                                  //                   ),
                                  //                   onTap: () async{
                                  //                     DateTime? pickedDate = await showDatePicker(
                                  //                         context: context,
                                  //                         firstDate: DateTime.now(),
                                  //                         lastDate: DateTime(2030)
                                  //                     );
                                  //                     if(pickedDate!=null){
                                  //                       setState(() {
                                  //
                                  //                       });
                                  //                       dateController.text="${pickedDate.day}, ${pickedDate.month}, ${pickedDate.year}";
                                  //                     }
                                  //                   }
                                  //
                                  //               ),
                                  //             ),
                                  //             SizedBox(width: 20,),
                                  //             SizedBox(width: 140,
                                  //               child: TextFormField(
                                  //                   controller: timeController,
                                  //                   style: TextStyle(
                                  //                       color: Colors.white),
                                  //                   decoration: InputDecoration(
                                  //                       hintText: "Time",
                                  //                       hintStyle: TextStyle(
                                  //                           color: Colors.white),
                                  //                       fillColor: Color(0xFF05243E),
                                  //                       filled: true,
                                  //                       prefixIcon: Icon(
                                  //                         Icons.access_time,
                                  //                         color: Colors.white,),
                                  //                       enabledBorder: OutlineInputBorder(
                                  //                           borderRadius: BorderRadius
                                  //                               .circular(10)
                                  //                       )
                                  //                   ),
                                  //                 onTap: () async {
                                  //                     TimeOfDay? pickTime =
                                  //                    await showTimePicker(
                                  //                         context: context,
                                  //                         initialTime:TimeOfDay.now());
                                  //
                                  //                     if(pickTime!=null){
                                  //                       setState(() {
                                  //
                                  //                       });
                                  //                       timeController.text= pickTime.format(context);
                                  //                     }
                                  //                 },
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ), SizedBox(height: 20,),
                                  //         Row(
                                  //           mainAxisAlignment: MainAxisAlignment.center,
                                  //           children: [
                                  //             ElevatedButton(onPressed: () {
                                  //
                                  //             }, style: ElevatedButton.styleFrom(
                                  //                 fixedSize: Size(140, 40),
                                  //                 shape: RoundedRectangleBorder(
                                  //                     borderRadius: BorderRadius
                                  //                         .circular(10)
                                  //                 )
                                  //
                                  //             ),
                                  //                 child: Text("Cancel")),
                                  //             SizedBox(width: 20,),
                                  //
                                  //             ElevatedButton(onPressed: () async {
                                  //               try {
                                  //                 var documentid = FirebaseFirestore.instance.collection("Task").doc().id;
                                  //                 Task taskdata = Task(
                                  //                     title: titleController.text, description: descriptionController.text, date: dateController.text,
                                  //                     time: timeController.text, docid: documentid,isCompleted: false);
                                  //
                                  //                 await FirebaseFirestore.instance.collection("Task").doc(documentid).set(taskdata.toJson());
                                  //                 Navigator.pop(context);
                                  //                setState(() {
                                  //
                                  //                });
                                  //               }
                                  //               catch (e) {}
                                  //             },
                                  //                 style: ElevatedButton.styleFrom(
                                  //                     fixedSize: Size(140, 40),
                                  //                     shape: RoundedRectangleBorder(
                                  //                         borderRadius: BorderRadius
                                  //                             .circular(10)
                                  //                     )
                                  //                 ),
                                  //                 child: Text("Create")),
                                  //
                                  //           ],
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),

                                }
                            );
                          },
                            backgroundColor: Color(0xff63D9F3),
                            shape: CircleBorder(),
                            child: Icon(Icons.add, color: Colors.white, size: 30,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
        );
  }
}
