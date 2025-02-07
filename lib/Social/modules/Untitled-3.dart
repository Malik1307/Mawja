import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Models/PostModel.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';

class CommentScreen extends StatelessWidget {
  final Postmodel postModel;
  const CommentScreen({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var loginCubit = LoginCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text("${postModel.name.split(" ").first}'s post "),
          ),
          body: Column(
                      children: [
          Container(
            color: Colors.white,
            // margin: const EdgeInsets.symmetric(horizontal: 8),
            // clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                            child: Image.network(
                          postModel.profile_image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    postModel.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.more_horiz))
                                ],
                              ),
                              // const SizedBox(
                              //   height: 0,
                              // ),
                              Text(
                                postModel.post_time,
                                //  "March 17, 2024 , at 11:55 pm",
                
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.grey[400],
                      width: double.infinity,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      postModel.description,
                      style: TextStyle(
                        height: 1.5,
                        // fontWeight: FontWeight.w400
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                
                    Card(
                      child: postModel.post_image == ""
                          ? null
                          : Image.network(
                              postModel.post_image!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                IconBroken.Heart,
                                color: Colors.redAccent,
                              ),
                            ),
                            Text(
                              postModel.postLikes.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700]),
                            )
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // SocialCubit.get(context)
                                //     .commentPost(postModel.postId);
                              },
                              icon: const Icon(
                                IconBroken.Chat,
                                color: Colors.amber,
                              ),
                            ),
                            Text(
                              postModel.postComments.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700]),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: Colors.grey[400],
                      width: double.infinity,
                      height: 1,
                    ),
                  // Spacer(),
                    Container(
                      padding: EdgeInsets.all(10),
                      
                      child: TextFormField(
                      
                      
                        
                        enabled: false,
                        keyboardType: TextInputType.none,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            //                         border: OutlineInputBorder(
                      
                            // // borderRadius: BorderRadius.circular(8.0), // Use a rounded border
                            // //       borderSide: BorderSide(
                            // //         color: Colors.grey[300]!, // Set a light border color
                            // //         width: 1.0, // Minimal border width
                            // //       ),
                            //                           ),
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                            hintText: " write a comment...",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipOval(
                                  child: Image.network(
                                loginCubit.profileImagePath != null
                                    ? loginCubit.profileImagePath!
                                    : loginCubit.gottenData!.profile_image,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .likePost(postModel.postId);
                                    },
                                    icon: Icon(
                                      true
                                          ? IconBroken.Heart
                                          : Icons.favorite_outlined,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                  Text(
                                    "Like",
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                    // SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          ),
                      ],
                    ),
        );
      },
    );
  }
}
// why the formfield not in the bottom of the page