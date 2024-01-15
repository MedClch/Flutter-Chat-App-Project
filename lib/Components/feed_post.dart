import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/helper_methods.dart';
import 'comment.dart';
import 'comment_button.dart';
import 'delete_button.dart';
import 'like_button.dart';

class FeedPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  final String time;

  const FeedPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time});

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
  }

  Future<int> getNumberOfComments() async {
    final querySnapshot = await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId)
        .collection("Comments").get();
    return querySnapshot.size;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }

  void addComment(String comment) {
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId)
        .collection("Comments").add({
      'CommentText': comment,
      'CommentedBy': currentUser!.email,
      'CommentTime': Timestamp.now()
    });
  }

  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add a comment'),
              content: TextField(
                controller: _commentTextController,
                decoration: InputDecoration(hintText: "Write a comment.."),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      addComment(_commentTextController.text);
                      Navigator.pop(context);
                      _commentTextController.clear();
                    },
                    child: Text("Post comment")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _commentTextController.clear();
                    },
                    child: Text("Cancel")),
              ],
            ));
  }

  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete post'),
              content: Text('Are you sure you want to delete this post ?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      final commentDocs = await FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .get();
                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection("User Posts")
                            .doc(widget.postId)
                            .collection("Comments")
                            .doc(doc.id)
                            .delete();
                      }
                      FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .delete()
                          .then((value) => print('Post deleted successfully'))
                          .catchError(
                              (error) => print('Failed to delete this post'));
                      Navigator.pop(context);
                    },
                    child: Text("Delete post")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, right: 25, left: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.message),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      Text(
                        " . ",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.user == currentUser!.email)
                DeleteButton(onTap: deletePost),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .snapshots(),
                    builder: (context, snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return CircularProgressIndicator();
                      // } else
                      if (snapshot.hasError) {
                        return Text('Error loading comments');
                      } else {
                        return Text(
                          snapshot.data!.docs.length.toString(),
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Column(
          //       children: [
          //         LikeButton(isLiked: isLiked,onTap: toggleLike,),
          //         SizedBox(height: 5,),
          //         Text(widget.likes.length.toString(),style: TextStyle(color: Colors.grey),),
          //       ],
          //     ),
          //     SizedBox(width: 15,),
          //     Column(
          //       children: [
          //         CommentButton(onTap:showCommentDialog,),
          //         SizedBox(height: 5,),
          //         Text('0',style: TextStyle(color: Colors.grey),),
          //       ],
          //     ),
          //   ],
          // ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return MyComment(
                      text: commentData['CommentText'],
                      user: commentData['CommentedBy'],
                      time: formatDate(commentData['CommentTime']));
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
