import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'model_class.dart';

class BottomSheetClass extends StatefulWidget {

  final Task ? task;

  const BottomSheetClass({super.key, this.task});

  @override
  State<BottomSheetClass> createState() => _BottomSheetClassState();
}

class _BottomSheetClassState extends State<BottomSheetClass> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController dateController = TextEditingController();
  late TextEditingController timeController = TextEditingController();
  final _formkey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task?.title ?? "";
      descriptionController.text = widget.task?.description ?? "";
      dateController.text = widget.task?.date  ?? "";
      timeController.text = widget.task?.time  ?? "";
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              SizedBox(width: 300,
                child: TextFormField(
                  controller: titleController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                          color: Colors.white),
                      fillColor: Color(0xFF05243E),
                      filled: true,
                      prefixIcon: Icon(Icons.task_alt,
                        color: Colors.white,),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius
                              .circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      )
                  ),
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(width: 300,
                child: TextFormField(maxLines: 5,
                    controller: descriptionController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Description",
                        hintStyle: TextStyle(
                            color: Colors.white),
                        fillColor: Color(0xFF05243E),
                        filled: true,

                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 100),
                          child: Icon(
                            Icons.density_small_sharp,
                            color: Colors.white,),
                        ),


                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    )
                ),
              ), SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 140,
                    child: TextFormField(
                        controller: dateController,
                        readOnly: true,
                        style: TextStyle(
                            color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Date",
                            hintStyle: TextStyle(
                                color: Colors.white),
                            fillColor: Color(0xFF05243E),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.date_range,
                              color: Colors.white,),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius
                                    .circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.transparent),
                            )
                        ),
                        onTap: () async{
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030)
                          );
                          if(pickedDate!=null){
                            setState(() {

                            });
                            dateController.text="${pickedDate.day}, ${pickedDate.month}, ${pickedDate.year}";
                          }
                        }

                    ),
                  ),
                  SizedBox(width: 20,),
                  SizedBox(width: 140,
                    child: TextFormField(
                      controller: timeController,
                      readOnly: true,
                      style: TextStyle(
                          color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Time",
                          hintStyle: TextStyle(
                              color: Colors.white),
                          fillColor: Color(0xFF05243E),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: Colors.white,),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius
                                  .circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.transparent),
                          )
                      ),
                      onTap: () async {
                        TimeOfDay? pickTime =
                        await showTimePicker(
                            context: context,
                            initialTime:TimeOfDay.now());

                        if(pickTime!=null){
                          setState(() {

                          });
                          timeController.text= pickTime.format(context);
                        }
                      },
                    ),
                  ),
                ],
              ), SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                  }, style: ElevatedButton.styleFrom(
                      fixedSize: Size(140, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .circular(10)
                      )

                  ),
                      child: Text("Cancel")),
                  SizedBox(width: 20,),

                  ElevatedButton(
                      onPressed: () async {
                       try {
                         if (widget.task == null) {
                           String id = FirebaseFirestore.instance
                               .collection("user")
                               .doc()
                               .id; // es se firestore my id set karty hai
                           await FirebaseFirestore.instance
                               .collection("user")
                           .doc(FirebaseAuth.instance.currentUser!.uid)
                           .collection("task")
                               .doc(id)
                               .set(
                             Task(
                               title: titleController.text,
                               description: descriptionController.text,
                               date: dateController.text,
                               time: timeController.text,
                               docid: id,
                               isCompleted: false,
                             ).toJson(),
                           );
                         } else {
                           await FirebaseFirestore.instance
                               .collection("user")
                           .doc(FirebaseAuth.instance.currentUser!.uid)
                           .collection("task")
                               .doc(widget.task!.docid)
                               .update({
                             "title": titleController.text,
                             "description": descriptionController.text,
                             "date": dateController.text,
                             "time": timeController.text,
                           });
                         }
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                        content: Text(widget.task == null ? "Task Created" : "Task Updated"),
                        backgroundColor: Colors.green,
                        ),
                        );
                        Navigator.pop(context, true);
                       }
                       catch(e){
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             content: Text("Error: ${e.toString()}"),
                             backgroundColor: Colors.red,
                           ),
                         );
                       }
                      },
                        style: ElevatedButton.styleFrom(
                        fixedSize: Size(140, 40),
                            shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                        )
                        ),
                      child: Text(widget.task == null ? "Create" : "Update"),
                  ),
                ],
              )
            ],
          ),
              ),
        ),
      ),
    );
  }
}
