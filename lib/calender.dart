import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todoapp/getx_controller_class.dart';
import 'package:todoapp/listscreen.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model_class.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

getxcontroller controller = Get.find<getxcontroller>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage your time",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
        backgroundColor: Color(0xff1253AA),
          leading: IconButton(
              onPressed: () {
               Get.back();
              }, icon:Icon(Icons.arrow_back_ios,color: Color(0xff63D9F3))
              ),),
      body: Container(
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column( crossAxisAlignment: CrossAxisAlignment.center,
                children: [SizedBox(height: 80,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white38,
                            Colors.white10
                          ]
                        ),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Obx(
                              ()=> TableCalendar(
                        focusedDay: controller.focusedDay.value,
                        firstDay: DateTime(1900), lastDay:DateTime(2100),

                        selectedDayPredicate: (day) =>
                            isSameDay(controller.selectedDay.value, day),

                        onDaySelected: (selectedDay, focusedDay) {
                          controller.selectedDay.value = selectedDay;
                          controller.focusedDay.value = focusedDay;

                          dateController.text =
                          "Set a task for ${selectedDay.day}-${selectedDay
                              .month}-${selectedDay.year}";
                        },
                        calendarStyle: CalendarStyle(
                                outsideTextStyle: TextStyle(
                                    color: Colors.white70),
                                defaultTextStyle: TextStyle(
                                    color: Colors.white),
                                weekendTextStyle: TextStyle(color: Colors.blue),
                                todayTextStyle: TextStyle(color: Colors.white),
                                todayDecoration: BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),

                                selectedDecoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    shape: BoxShape.circle)

                            ),
                            headerStyle:
                            HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(color: Colors.white),
                                leftChevronIcon: Icon(
                                  Icons.chevron_left, color: Colors.blue,),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right, color: Colors.blue,)
                            ),
                            daysOfWeekStyle:
                            DaysOfWeekStyle(
                                weekdayStyle: TextStyle(color: Colors.white),
                                weekendStyle: TextStyle(color: Colors.blue)
                            )
                        ),
                    ),
                    ),
                  ),
                      SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                      child: Column(
                        children: [
                     Obx(()=> TextField(
                        controller: dateController,
                         readOnly: true,
                          decoration : InputDecoration(
                            hintText: controller.selectedDay.value != null
                              ? "Set a task for ${controller.selectedDay.value!.day}-${controller.selectedDay.value!.month}-${controller.selectedDay.value!.year}"
                              : "Set a task for this date",
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                  ),
                          Row( mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(height: 40,
                                  child: TextField(
                                    controller: titleController,
                                    style: TextStyle(color: Colors.white,),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xff05243E),
                                      hintText: "Task", hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none
                                      )

                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                             Obx(()=> ElevatedButton(onPressed: controller.isloading.value ? null : ()async{
                                if (titleController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please enter a task title!"),
                                      backgroundColor:  Color(0xff05243E),
                                    ),
                                  );
                                  return;
                                }

                                  controller.isloading.value = true;

                                  try {
                                    String id =FirebaseFirestore.instance
                                        .collection("user")
                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("task")
                                    .doc().
                                    id;

                                    Task model = Task(title: titleController.text,
                                        description: descriptionController.text,
                                        date: dateController.text,
                                        time: timeController.text,
                                        docid: id,
                                        isCompleted: false);

                                    titleController.clear();
                                    descriptionController.clear();
                                    dateController.clear();
                                    timeController.clear();


                                 await  FirebaseFirestore.instance.collection(
                                        "user")
                                     .doc(FirebaseAuth.instance.currentUser!.uid)
                                     .collection("task")
                                    .doc(id).set(model.toJson());

                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added Sucessfully")));



                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Task added Successfully"), backgroundColor: Colors.green)
                                    );
                                    Get.offAll(HomeScreen());
                                  }
                                  catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Error: ${e.toString()}")));
                                  }finally{

                                      controller.isloading.value= false;

                                  }
                                },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff05243E),
                                    textStyle: TextStyle(color: Colors.white)
                                  ),
                                  child: controller.isloading.value ? SizedBox(
                                    height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,),
                                  )
                                          : Text("Submit",style: TextStyle(color: Colors.white),))
                             )
                            ],
                          )
                     ]
                      )
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
