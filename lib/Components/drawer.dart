import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final Function()? onProfileTap;
  final Function()? onLogoutTap;
  const MyDrawer({super.key, this.onProfileTap, this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          DrawerHeader(child: Icon(Icons.person,color: Colors.white,size: 55,)),
          SizedBox(height: 15,),
          Text(currentUser.email!,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          SizedBox(height: 35,),
          MyListTile(icon: Icons.home, text: 'H O M E',onTap: ()=> Navigator.pop(context),),
          MyListTile(icon: Icons.person, text: 'P R O F I L E',onTap: onProfileTap,),
          SizedBox(height: 420,),
          MyListTile(icon: Icons.logout, text: 'L O G O U T',onTap: onLogoutTap,),
        ],
      ),
    );
  }
}

//