import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:intl/intl.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Models/PostModel.dart';
import 'package:social_test/Models/commen_model.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/Social/Social_Layout.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatelessWidget {
  final Postmodel postModel;
  const CommentScreen({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      LoginCubit.get(context).GetData();
      SocialCubit.get(context).getComments(postId: postModel.postId);

      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var loginCubit = LoginCubit.get(context);
          var cubit = SocialCubit.get(context);

          var commentController = TextEditingController();
          var formKey = GlobalKey<FormState>();
          return Scaffold(
            // backgroundColor: Colors.white,
            appBar: AppBar(
              // backgroundColor: Colors.white,
              centerTitle: true,
              title: Text("${postModel.name.split(" ").first}'s post "),
              leading:IconButton(onPressed: ()=>NavigatReplace(context,const Social_Layout()), icon: const Icon(IconBroken.Arrow___Left)) ,
            ),
            body: state is AppLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Post details at the top
                              Container(
                                // color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      postModel.name,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.more_horiz),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  postModel.post_time,
                                                  style: TextStyle(
                                                      color: Colors.grey[600]),
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
                                        style: const TextStyle(height: 1.5),
                                      ),
                                      const SizedBox(height: 10),
                                      Card(
                                        child: postModel.post_image == ""
                                            ? null
                                            : Image.network(
                                                postModel.post_image!,
                                                height: 200,
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
                                                  icon: const CircleAvatar(
                                                    radius: 13,
                                                    backgroundColor:
                                                        Colors.blue,
                                                    child: Icon(
                                                      Icons.thumb_up_alt,
                                                      size: 18,
                                                      color:  Colors.white,
                                                    ),
                                                  )),
                                              Text(
                                                postModel.postLikes.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              const Icon(
                                                IconBroken.Chat,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(width: 10,),
                                              Text(
                                                postModel.postComments
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        color: Colors.grey[400],
                                        width: double.infinity,
                                        height: 1,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                              // Comments section
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) => const SizedBox(
                                  height: 5,
                                ),
                                itemBuilder: (context, index) {
                                  return comment(cubit.comments[index]);
                                },
                                itemCount: cubit.comments.length,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Fixed TextFormField at the bottom
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                          validator: (value) {
                          if (value!.isEmpty)
                          return "fill the comment field";
                          return null;
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty &&
                                  loginCubit.gottenData != null)
                                cubit.addComment(
                                  context,
                                  profileImage:
                                      loginCubit.gottenData!.profile_image,
                                  postId: postModel.postId,
                                  comment: commentController.text,
                                  // image: ""
                                );
                            },
                            controller: commentController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: " write a comment...",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate())
                                    cubit.addComment(
                                      context,
                                      profileImage:
                                          loginCubit.gottenData!.profile_image,
                                      postId: postModel.postId,
                                      comment: commentController.text,
                                      // image: ""
                                    );
                                },
                                icon: const Icon(
                                  IconBroken.Send,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      );
    });
  }
}

Widget comment(CommentModel modelComment) {
  DateTime commentDateTime =
  DateFormat("dd MMMM yyyy, h:mm a").parse(modelComment.commentTime);

  String timeAgo = timeago.format(commentDateTime);

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.network(
              modelComment.profileImage,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      // color: const Color(0xffF0F2F5),
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modelComment.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        modelComment.comment,
                        style: GoogleFonts.openSans(),
                      ),
                    ],
                  ),
                ),
                Text(
                  timeAgo,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
