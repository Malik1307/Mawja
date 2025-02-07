import 'package:flutter/material.dart';
import 'package:social_test/Models/PostModel.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/modules/edit_post.dart';
import 'package:social_test/main.dart';

class ReportedPost extends StatelessWidget {
  final Postmodel postModel;

  const ReportedPost({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reported Post'),
      ),
      body: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40,),
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      postModel.profile_image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              postModel.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  if (postModel.uID == uID)
                                    PopupMenuItem(
                                      child: const Text("Edit"),
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return EditPost(model: postModel);
                                        },
                                      ),
                                    ),
                                  if (postModel.uID == uID)
                                    PopupMenuItem(
                                      child: const Text("Delete"),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              actionsAlignment: MainAxisAlignment.end,
                                              title: const Row(
                                                children: [
                                                  Icon(Icons.warning, color: Colors.red),
                                                  SizedBox(width: 10),
                                                  Text('Delete Post'),
                                                ],
                                              ),
                                              content: const Text('Are you sure you want to delete your post?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Close the dialog
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    SocialCubit.get(context).deletePost(postModel.postId);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        'Delete',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  if (postModel.uID != uID)
                                    const PopupMenuItem(
                                      child: Text("Report"),
                                    ),
                                ];
                              },
                              icon: const Icon(Icons.more_horiz),
                            ),
                          ],
                        ),
                        Text(
                          postModel.post_time,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.grey[400],
                width: double.infinity,
                height: 1,
              ),
              const SizedBox(height: 10),
              Text(
                postModel.description,
                style: const TextStyle(
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              if (postModel.post_image != "" )
                Card(
                  child: Image.network(
                    postModel.post_image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
