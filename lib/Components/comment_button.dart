import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final Function()? onTap;

  CommentButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.comment,color: Colors.grey,
      ),
    );
  }
}