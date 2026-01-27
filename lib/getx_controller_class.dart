import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'model_class.dart';

class getxcontroller extends GetxController {
  RxBool isloading = true.obs;
  RxBool isProfileloading = true.obs;
  var searchQuery = ''.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);

  RxList<Task> allTask = <Task>[].obs;
  RxList<Task> search = <Task>[].obs;
  RxList<Task> incompleteTask =<Task>[].obs;
  RxList<Task> completeTask =<Task>[].obs;

  var profileImageUrl = RxnString();
  var userName= RxnString();
  var userEmail= RxnString();


  final user = FirebaseAuth.instance.currentUser;
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getTask();
    getProfile();

  }
  void getTask()async {
   try{
     isloading.value = true;

     final uid = FirebaseAuth.instance.currentUser!.uid;


     FirebaseFirestore.instance
         .collection("user")
         .doc(uid)
         .collection('task')
         .snapshots()
         .listen((snapshot) {

  final  tasks = snapshot.docs.map((doc) => Task.fromJson(doc.data()))
           .toList();
  allTask.assignAll(tasks);
  search.assignAll(tasks);
  incompleteTask.assignAll((tasks.where((tasks)=> tasks.isCompleted == false).toList()));
      completeTask.assignAll((tasks.where((tasks)=> tasks.isCompleted == true).toList()));

       isloading.value = false;

  if (searchQuery.value.isNotEmpty) {
    search.assignAll(
        tasks.where((task) => task.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList()
    );
     }
         }
         );
   }
   catch(e){
     Get.snackbar("Task upload error",e.toString());
     isloading.value= false;
   }
}



  void getProfile() async {
    try {
      isProfileloading.value = true;
      final uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .snapshots()
          .listen((snapshot){
        if(snapshot.exists){
          var data = snapshot.data();
          profileImageUrl.value = data?['profile_image'];
          userName.value = data?['name'] ?? user?.displayName;
          userEmail.value = data?['email'] ?? user?.email;
        }
        isProfileloading.value= false;
      },
      );
    }
    catch (e) {
      Get.snackbar("Profile Error", e.toString());

    }finally{
      isProfileloading.value= false;
    }
  }


  Future<void> doneTask(String docId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .collection("task")
          .doc(docId)
          .update({"isCompleted": true});

    } catch (e) {
      Get.snackbar("Done is Failed,",e.toString());
    }
  }

  Future<void> deleteTask(String docId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .collection("task")
          .doc(docId)
          .delete();


    } catch (e) {
      Get.snackbar("Delete Error", "Failed to delete task.");
    }
  }

  Future<Task?> updateTask(String docId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .collection("task")
          .doc(docId)
          .get();

      if (doc.exists && doc.data() != null) {
        return Task.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      Get.snackbar("Update Error", "Failed to fetch updated task.");
      return null;
    }
  }
  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;

    String selectedDate =
        "${selected.day}-${selected.month}-${selected.year}";

    search.assignAll(
      allTask.where((task) => task.date.contains(selectedDate)).toList(),
    );
  }

}