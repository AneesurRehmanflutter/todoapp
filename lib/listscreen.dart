import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/calender.dart';
import 'package:todoapp/homescreen.dart';
import 'package:todoapp/model_class.dart';
import 'package:todoapp/setting.dart';
import 'package:todoapp/task_details.dart';
import 'package:todoapp/task_provider_class.dart';

import 'bottomsheet_class.dart';

class Listscreen extends StatefulWidget {
  const Listscreen({super.key});

  @override
  State<Listscreen> createState() => _ListScreenState();
}
class _ListScreenState extends State<Listscreen> {
  final TextEditingController searchController= TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String searchText= "";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider= context.read<TaskProviderClass>();
    provider.getTask();
  }
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
                                  setState(() {
                                    searchText = value.toLowerCase();
                                  });
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
                    child: Consumer<TaskProviderClass>(// for subcollection or user collection
                    //FirebaseFirestore.instance.collection("user").snapshots(),
                        builder:(context, provider, child) {
                      if (provider.isloading) {
                    return Center(child: CircularProgressIndicator(color: Colors.white,));
                      }
                    //   if (snapshot.hasError) {
                    // return Center(child: Text(snapshot.error.toString(), style: TextStyle(color: Colors.white),));
                    //   }
                    //   if (!provider.hasData || provider.data!.docs.isEmpty) {
                    // return Center(child: Text("no data found", style: TextStyle(color: Colors.white),));
                    //   }
                    //
                    //   final alltask = snapshot.data!.docs;
                    //
                    //   final filteredtask = alltask.where((doc){
                    //     final title= (doc.data() as Map<String, dynamic>)["title"].toString().toLowerCase();
                    //     return title.contains(searchText);
                    //   }).toList();

                      return ListView.builder(
                    itemCount: provider.allTask.length,
                    itemBuilder: (context, int index) {
                      final model = provider.allTask[index];
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
                                    Navigator.push(context, MaterialPageRoute<void>(builder: (context)=> TaskDetails(task: model)));

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
