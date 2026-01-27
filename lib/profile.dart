import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todoapp/main.dart';

import 'log_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userEmail;
  String? userName;

  File? _imageFile;
  String? dbImage;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    if (user == null) return;
    try {

      userEmail = user!.email;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userEmail = user!.email;

          dbImage = userDoc.get('profile_image');

          userName = userDoc.data().toString().contains('name')
              ? userDoc.get('name')
              : "No name";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  final user = FirebaseAuth.instance.currentUser;

  Future pickImage () async{
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(context: context,
        backgroundColor: Color(0xff05243E),
        builder: (context){
      return Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [ SizedBox(height: 10,),
          Text("Profile Photo", style: TextStyle(
          fontSize: 30,
            color: Colors.white
        ),),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.camera_alt,color: Colors.white,),
            title: Text("Camera",style: TextStyle(
              color: Colors.white
            ),
            ),
            onTap: ()async {
            Get.back();
              final XFile? image = await picker.pickImage(source: ImageSource.camera);
            if( image != null){
              setState(() {
                _imageFile = File(image.path);
              }
              );
              confirmationDialog();
            }
              },
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.image, color: Colors.white,),
            title: Text("Gallery",style: TextStyle(
                color: Colors.white
            )),
            onTap:  ()async {
            Get.back();
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              if( image != null){
                setState(() {
                  _imageFile = File(image.path);
                }
                );
                confirmationDialog();
              }
            },
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.white,),
            title: Text("Delete",style: TextStyle(
                color: Colors.white
            )), 
            onTap: ()async{
             try{
               Get.back();
              await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
              'profile_image': FieldValue.delete(),
              }
              );
              setState(() {
                dbImage = null;
                _imageFile= null;
              });
             }
             catch(e){}
            },
          ),
        ],
      );
    });
  }
  Future uploadImage() async{
    if(_imageFile == null) return;

    setState(() {
      loading = true;
    });
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final filename= DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'uploads/$filename';

    try{
      await Supabase.instance.client.storage.from('images').upload(path, _imageFile!);
      var imageUrl = Supabase.instance.client.storage.from('images').getPublicUrl(path).toString();
      await FirebaseFirestore.instance.collection("user").doc(uid).update(
          {'profile_image': imageUrl});
      if(!mounted) return;

      setState(() {
        dbImage = imageUrl;
        _imageFile = null;
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Sucessfully Uploaded")));

    }
   catch(e){
      if(!mounted) return;
      setState(() {
        loading =false;
        _imageFile= null;
      });
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image not Sucessfully updated")));

   }
  }
  Future<void> confirmationDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to update profile picture?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                setState(() {
                  _imageFile = null;
                });
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back();
                await uploadImage();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }


  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: Text("Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
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
child: Column( mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Stack(
      children:[ CircleAvatar(
          radius: 100,
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!) as ImageProvider
              : (dbImage != null
              ? NetworkImage(dbImage!) as ImageProvider
              : null),
          child: (_imageFile == null && dbImage == null)
              ? const Icon(
            Icons.add_a_photo,
            size: 40,
          ) : null
      )
      ]
    ),

    SizedBox(height: 20,),
    ElevatedButton(
      onPressed: loading ? null : pickImage,
      child: loading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Text("Edit"),
    ),
ListTile(
  leading: Icon(Icons.people,color: Colors.white,size: 25,),
  title: Text("Name",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 17),),
  subtitle: Text(userName ?? "username",style: TextStyle(color: Colors.white,fontSize: 15 ),),
),
    SizedBox(height: 10,),
    ListTile(
      leading: Icon(Icons.email,color: Colors.white,size: 25,),
      title: Text("Email address",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 17),),
      subtitle: Text(userEmail ?? "user@gmail.com",style: TextStyle(color: Colors.white,fontSize: 15 ),),
    ),
    SizedBox(height: 10,),
    ListTile(
      leading: Icon(Icons.emoji_emotions,color: Colors.white,size: 25,),
      title: Text("About",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 17),),
      subtitle: Text("Bio",style: TextStyle(color: Colors.white,fontSize: 15 ),),
    ),
    SizedBox(width: 260,
      height: 62,
      child: OutlinedButton.icon(
        onPressed: loading ? null :
            () async{
          setState(() {
            loading = true;
          });
          try {
            await FirebaseAuth.instance.signOut();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Log Out Successfully")));
          Get.off(LogIn());
          }
          catch(e){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Logout Field Please Try Again"),
                )
            );
          }finally{
            setState(() {
              loading= false;
            });
          }
        },
        icon: loading ? SizedBox(height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Color(0xff05243E),
            strokeWidth: 2,
          ),
        ) :
        Icon(Icons.logout_outlined, color: Colors.red, size: 30,),
        label: loading ? Text("") : Text("Logout", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w500,
        ),
        ),
        style:OutlinedButton.styleFrom(backgroundColor: Colors.white),
      ),
    )
  ],
),
)
    );
  }
}