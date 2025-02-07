import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Models/PostModel.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/Social/Social_Layout.dart';
import 'package:social_test/Social/modules/comment_screen.dart';
import 'package:social_test/Social/modules/edit_post.dart';
import 'package:social_test/Social/modules/make_report.dart';
import 'package:social_test/main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double width = Width(context);
    double height = Height(context);
    bool loading = false;
    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is Loadin_Edit) {
        print("loading edit");
      }
      if (state is Edit_Post_Success) Navigator.pop(context);
      if (state is Edit_Post_Success ||
          // state is Delete_Post_Success||
          // state is AppLoading ||
          state is Loadin_Edit) NavigatReplace(context, const Social_Layout());
    }, builder: (context, state) {
      var cubit = SocialCubit.get(context);
      return state is Loadin_Edit?
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Card(
                  //   margin: const EdgeInsets.all(8),
                  //   elevation: 5,
                  //   clipBehavior: Clip.antiAliasWithSaveLayer,
                  //   child: Image.asset(
                  //     "images/11.jpg",
                  //     width: double.infinity,
                  //     height: height / 4,
                  //     fit: BoxFit.fitWidth,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => BuildFeed(
                      cubit.ListPostModel![index],
                      context,
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 22,
                    ),
                    itemCount: cubit.ListPostModel!.length,
                  )
                ],
              ),
            );
    });
  }
}

Widget BuildFeed(Postmodel model, context) {
  var loginCubit = LoginCubit.get(context);

  return Card(
    elevation: 5,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                  child: Image.network(
                model.profile_image,
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
                          model.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              if (model.uID == uID)
                                PopupMenuItem(
                                    child: const Text("Edit"),
                                    onTap: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return EditPost(model: model);
                                          },
                                        )),
                              if (model.uID == uID)
                                PopupMenuItem(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          actionsAlignment:
                                              MainAxisAlignment.end,
                                          title: const Row(
                                            children: [
                                              Icon(Icons.warning,
                                                  color: Colors.red),
                                              SizedBox(
                                                  width:
                                                      10), // Add some space between the icon and the text
                                              Text('Delete Post'),
                                            ],
                                          ),
                                          content: const Text(
                                              'Are you sure you want to delete your post?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                SocialCubit.get(context)
                                                    .deletePost(model.postId);
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                  height: 40,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: const Center(
                                                      child: Text(
                                                    'Delete',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("Delete"),
                                ),
                              if (model.uID != uID)
                                PopupMenuItem(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MakeReport(model: model);
                                      },
                                    );
                                  },
                                  child: const Text("Report"),
                                ),
                            ];
                          },
                          icon: const Icon(Icons.more_horiz),
                        )
                      ],
                    ),
                    // const SizedBox(
                    //   height: 0,
                    // ),
                    Text(
                      model.post_time,
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
            model.description,
            style: const TextStyle(
              height: 1.5,
              // fontWeight: FontWeight.w400
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          /*  Wrap(
            // runSpacing: 20,
            spacing: 2.3,
            runSpacing: 0,
            // alignment: WrapAlignment.start,
            // spacing: 0,
            // runSpacing: 0,
            // alignment: WrapAlignment.start,
            // crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(
                      0,
                    ),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {},
                child: const Text(
                  "#Web Development",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(
                      0,
                    ),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {},
                child: const Text(
                  "#Web Development",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(
                      0,
                    ),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {},
                child: const Text(
                  "#Web Development",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(
                      0,
                    ),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {},
                child: const Text(
                  "#Web Development",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          */
          Card(
            child: model.post_image == ""
                ? null
                : Image.network(
                    model.post_image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "images/images9.png",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
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
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.thumb_up_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      )),
                  Text(
                    model.postLikes.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey[700]),
                  )
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // SocialCubit.get(context).commentPost(model.postId);
                    },
                    icon: const Icon(
                      IconBroken.Chat,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    model.postComments.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey[700]),
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
          const SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: () {
                Navigat(context, CommentScreen(postModel: model));
              },
              child: Row(
                children: [
                  if (loginCubit.gottenData != null)
                    Padding(
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
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    "write a comment ...",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          "LIKE",
                          style: TextStyle(
                              color: Colors.blue[500],
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          SocialCubit.get(context).likePost(model.postId);
                        },
                        // icon: CircleAvatar(
                        //                           radius: 13,
                        //                           backgroundColor: Colors.blue,
                        //                           child: Icon(
                        //                             Icons.thumb_up_alt,
                        //                             size: 18,
                        //                             color: Colors.white,
                        //                           ),
                        //                         )
                      ),
                      //  SizedBox(
                      //    width: 5,
                      //  ),

                      //    SizedBox(
                      //    width: 5,
                      //  ),
                    ],
                  )
                ],
              )

              // TextFormField(
              //   enabled: false,
              //   keyboardType: TextInputType.none,

              //   decoration: InputDecoration(
              //       border: const OutlineInputBorder(borderSide: BorderSide.none),
              //       //                         border: OutlineInputBorder(

              //       // // borderRadius: BorderRadius.circular(8.0), // Use a rounded border
              //       // //       borderSide: BorderSide(
              //       // //         color: Colors.grey[300]!, // Set a light border color
              //       // //         width: 1.0, // Minimal border width
              //       // //       ),
              //       //                           ),
              //       hintStyle: const TextStyle(
              //           color: Colors.grey, fontWeight: FontWeight.bold),
              //       hintText: " write a comment...",
              //       prefixIcon: Padding(
              //         padding: const EdgeInsets.all(5.0),
              //         child: ClipOval(
              //             child: Image.network(
              //           loginCubit.profileImagePath != null
              //               ? loginCubit.profileImagePath!
              //               : loginCubit.gottenData!.profile_image,
              //           width: 40,
              //           height: 40,
              //           fit: BoxFit.cover,
              //         )),
              //       ),
              //       suffixIcon: InkWell(
              //         onTap: () {},
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             IconButton(
              //               onPressed: () {
              //                 SocialCubit.get(context).likePost(model.postId);
              //               },
              //               icon: Icon(
              //                 true ? IconBroken.Heart : Icons.favorite_outlined,
              //                 color: Colors.redAccent,
              //               ),
              //             ),
              //             // SizedBox(
              //             //   width: 5,
              //             // ),
              //             Text(
              //               "Like",
              //               style: TextStyle(
              //                   color: Colors.grey[500],
              //                   fontWeight: FontWeight.bold),
              //             )
              //           ],
              //         ),
              //       )),
              // ),
              ),
          // SizedBox(height: 10,)
        ],
      ),
    ),
  );
}
