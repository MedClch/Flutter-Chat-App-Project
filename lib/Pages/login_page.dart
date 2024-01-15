import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Components/button.dart';
import '../Components/password_field.dart';
import '../Components/text_field.dart';
import '../helper/helper_methods.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  List<TextEditingController> lstControllers = [];

  void signIn() async{
    showDialog(context: context, builder: (context)=>Center(child: CircularProgressIndicator(),));
    lstControllers.add(emailTextController);
    lstControllers.add(passwordTextController);
    if(!isValidForm(lstControllers)) {
      Navigator.pop(context);
      showMessage('Please fill the full login form');
    }
    else if (!isEmailValid(emailTextController.text)) {
      Navigator.pop(context);
      showMessage('Please enter a valid email address !');
    }
    else{
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailTextController.text,
            password: passwordTextController.text
        );
        if(context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch(err){
        Navigator.pop(context);
        showMessage(err.code);
      }
    }
  }

  void showMessage(String message){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,//
                size: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Welcome back to BreezeTalk, you've been missed !",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              //
              SizedBox(
                height: 25,
              ),
              MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false),
              SizedBox(
                height: 10,
              ),
              MyPasswordTextField(
                controller: passwordTextController,
                hintText: 'Password',
              ),
              // MyTextField(
              //     controller: passwordTextController,
              //     hintText: 'Password',
              //     obscureText: true),
              SizedBox(
                height: 10,
              ),
              MyButton(onTap: signIn, text: 'Sign in'),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member ?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
