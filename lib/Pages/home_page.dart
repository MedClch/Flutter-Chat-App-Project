import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/profile_page.dart';

import '../Components/drawer.dart';
import '../Components/feed_post.dart';
import '../Components/text_field.dart';
import '../helper/helper_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  void postMessage(){
    if(textController.text.isNotEmpty){
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail' : currentUser.email,
        'Message' : textController.text,
        'TimeStamp' : Timestamp.now(),
        'Likes' : [],
      });
    }
    setState(() {
      textController.clear();
    });
  }

  void goToProfile(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(title: Text("BreezeTalk",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.grey[400],
      ),
      drawer: MyDrawer(onLogoutTap: signOut,onProfileTap:goToProfile,),
      body: Center(
        child: Column(
          children: [
            Expanded(child: StreamBuilder(stream: FirebaseFirestore.instance.collection("User Posts").orderBy("TimeStamp",descending: false).snapshots(),
                builder: (context,snapshot){
               if(snapshot.hasData){
                 return ListView.builder(itemCount: snapshot.data!.docs.length, itemBuilder: (context,index){
                   final post = snapshot.data!.docs[index];
                   return FeedPost(message: post['Message'], user: post['UserEmail'],postId: post.id,
                     likes: List<String>.from(post['Likes'] ?? []),time: formatDate(post['TimeStamp']),);
                 });
               }else if(snapshot.hasError){
                 return Center(child: Text('Error : ${snapshot.error}'),
                 );
               }
               return Center(child: CircularProgressIndicator(),);
                })
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(child: MyTextField(controller: textController,
                    hintText: "Post or write something here ...",obscureText: false,)
                  ),
                  IconButton(onPressed: postMessage, icon: Icon(Icons.arrow_circle_up)
                  ),
                ],
              ),
            ),
            Text("Logged in as "+currentUser.email!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
