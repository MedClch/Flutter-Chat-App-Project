import 'package:flutter/material.dart';

class MyComment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const MyComment({super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[400],borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          SizedBox(height: 5,),
          Row(
            children: [
              Text(user,style: TextStyle(color: Colors.grey[600]),),
              Text(" . ",style: TextStyle(color: Colors.grey[600]),),
              Text(time,style: TextStyle(color: Colors.grey[600]),),
            ],
          ),
        ],
      ),
    );
  }
}
