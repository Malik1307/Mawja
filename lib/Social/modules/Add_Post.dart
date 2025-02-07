import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/Social/Social_Layout.dart';

class Adding_Post extends StatelessWidget {
  const Adding_Post({super.key});

  @override
  Widget build(BuildContext context) {
    var postController = TextEditingController();
    return BlocProvider(
      create: (context) => SocialCubit()..GetPostsData(),
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if (state is Upload_Post_Success)
            NavigatReplace(context, const Social_Layout());
        },
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);
          LoginCubit loginCubit = LoginCubit.get(context);
          return  cubit.ListPostModel!.isEmpty? const Center(child: CircularProgressIndicator(),): Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () {
                      cubit.createPost(
                        context,
                        description: postController.text,
                      );
                    },
                child:     const Text( "Post",style: TextStyle(color: Colors.blue),))
              ],
              title: const Text("Add Post"),
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: loginCubit.profileImagePath != null
                            ? NetworkImage(loginCubit.profileImagePath!)
                            : NetworkImage(
                                loginCubit.gottenData!.profile_image,
                              ),
                        radius: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            loginCubit.gottenData!.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          // Spacer(),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "public",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: postController,
                      decoration: InputDecoration(
                          hintText:
                              "whats in your mind, ${loginCubit.gottenData!.name.split(" ").first} ?",
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                  ),
                  if (cubit.PostImage != null) Image.file(cubit.PostImage!),
                  const Spacer(),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Expanded(
                        child: InkWell(
                          //TextButton Row
                          onTap: () {
                            cubit.getPostimage();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    IconBroken.Image_2,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Add Image",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Center(
                              child: Text(
                                "# tags",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
