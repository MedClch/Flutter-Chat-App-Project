import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp){
  DateTime dateTime = timestamp.toDate();
  String year = dateTime.year.toString();
  String day = dateTime.day.toString();
  String month = dateTime.month.toString();
  String formattedDate = '$day/$month/$year';
  return formattedDate;
}

bool isValidForm(List<TextEditingController> lst){
  for(var x in lst){
    if(x.text.trim().isEmpty) {
      return false;
    }
  }
  return true;
}

bool isEmailValid(String email) {
  String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}