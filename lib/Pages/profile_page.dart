import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final confirmPasswordTextController1 = TextEditingController();

  Future<void> editField(String field) async {
    String field1 = field.toLowerCase();
    String newVal = "";
    if (field1 == 'password') {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Edit $field1",
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordTextController,
                autofocus: true,
                style: TextStyle(color: Colors.black),
                obscureText: true, // To hide the entered password
                decoration: InputDecoration(
                  hintText: "Enter current password",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newVal = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordTextController,
                style: TextStyle(color: Colors.black),
                obscureText: true, // To hide the entered password
                decoration: InputDecoration(
                  hintText: "Enter new password",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newVal = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordTextController1,
                style: TextStyle(color: Colors.black),
                obscureText: true, // To hide the entered password
                decoration: InputDecoration(
                  hintText: "Confirm new password",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newVal = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(newVal);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      );
      if (newVal.trim().length > 0) {
        await updatePassword(newVal);
      }
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Edit $field1",
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Enter new $field1",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newVal = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(newVal);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      );
      if (newVal.trim().length > 0) {
        await usersCollection.doc(currentUser.email).update({field: newVal});
      }
    }
  }

  Future<void> updatePassword(String newPassword) async {
    if(confirmPasswordTextController1.text.trim()!=confirmPasswordTextController.text.trim()){
      showMessage("Passwords don't match ! Please try again");
      passwordTextController.clear();
      confirmPasswordTextController.clear();
      confirmPasswordTextController1.clear();
    }
    else if(passwordTextController.text.trim().isEmpty||confirmPasswordTextController.text.trim().isEmpty){
      Navigator.pop(context);
    }
    else {
      try {
        await currentUser.updatePassword(newPassword);
        showMessage("Password updated successfully");
        passwordTextController.clear();
        confirmPasswordTextController.clear();
        confirmPasswordTextController1.clear();
      } catch (e) {
        showMessage("Error updating password");
      }
    }
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  // void showMessage(String message){
  //   showDialog(context: context, builder: (context)=> AlertDialog(
  //     title: Text(message),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile page',style :TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
        ,backgroundColor: Colors.grey[600],),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final userData = snapshot.data!.data() as Map<String,dynamic>;
            return ListView(
              children: [
                SizedBox(height: 50,),
                Icon(Icons.person,size: 70,),
                SizedBox(height: 10,),
                Text(currentUser.email!,textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold),),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text('My informations : ',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold),),
                ),
                MyTextBox(text: userData['Username'], sectionName: 'Username',onPressed: () => editField('Username'),),
                MyTextBox(text: userData['Full name'], sectionName: 'Full name',onPressed: () => editField('Full name'),),
                MyTextBox(text: userData['Bio'], sectionName: 'User bio',onPressed: () => editField('Bio'),),
                MyTextBox(text: '', sectionName: 'Password',onPressed: () => editField('Password'),),
                SizedBox(height: 50,),
              ],
            );
          }else if(snapshot.hasError){
            return Center(child: Text('Error : ${snapshot.error}'),
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
