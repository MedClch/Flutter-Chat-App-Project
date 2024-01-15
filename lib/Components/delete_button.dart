import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function()? onTap;
  const DeleteButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.delete_forever,color: Colors.black45,),
    );
  }
}
