import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model_class.dart';

class TaskProviderClass extends ChangeNotifier {
  bool isloading = true;
  bool isProfileloading = true;

  List<Task> allTask = [];
  List<Task> incompleteTask = [];
  List<Task> completeTask = [];

  String? profileImageUrl;
  String? userName;
  String? userEmail;

final user = FirebaseAuth.instance.currentUser;

  void getTask() {
    isloading = true;
    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser!.uid;


    FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection('task')
        .snapshots()
        .listen((snapshot) {

      allTask = snapshot.docs.map((doc) => Task.fromJson(doc.data()))
          .toList();

      incompleteTask = allTask.where((task) => task.isCompleted == false).toList();
      completeTask = allTask.where((task) => task.isCompleted == true).toList();

      isloading = false;
      notifyListeners();
    });
  }

  void getProfile()  {
    try {
      isProfileloading = true;
      notifyListeners();
      final uid = FirebaseAuth.instance.currentUser!.uid;
       FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
      .snapshots()
      .listen((snapshot){
        if(snapshot.exists){
          var data = snapshot.data();
          profileImageUrl = data?['profile_image'];
          userName = data?['name'] ?? user?.displayName;
          userEmail = data?['email'] ?? user?.email;
        }
        isProfileloading= false;
        notifyListeners();
      },
      );

      }catch (e) {
      debugPrint("Error getting profile: $e");
      isProfileloading = false;
      notifyListeners();
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

    } catch (e) {}
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


    } catch (e) {}
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
      return null;
    }
  }

  }

