import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:iconly/iconly.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Login/Cubit/Login_CubitStates.dart';
import 'package:social_test/Social/modules/Profile.dart';
//many bloc providers

class Edit_Profile extends StatelessWidget {
  const Edit_Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocProvider(
      create: (context) => LoginCubit()..GetData(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is Update_Data_Success)
            Snake(
                titleWidget: const Text("Updated data Successfully"),
                context: context,
                EnumColor: Messages.Success);  if (state is Update_Data_Failed)
            Snake(
                titleWidget: const Text("Updated data failed"),
                context: context,
                EnumColor: Messages.Error);


          // if (state is Profile_image_Success)
          //   print("Listner" + LoginCubit.get(context).profileImage.toString());
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);

          if (cubit.gottenData != null) {
            nameController.text = LoginCubit.get(context).gottenData!.name;
            phoneController.text = LoginCubit.get(context).gottenData!.phone;
            emailController.text = LoginCubit.get(context).gottenData!.email;
          }
          return   Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    NavigatReplace(context, const Profile());
                  },
                  icon: const Icon(IconBroken.Arrow___Left_2)),
            ),
            body: 
            
                          state is Loading?const Center(child: CircularProgressIndicator(),):

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (state is Update_Data_Loading)
                    const SizedBox(
                      height: 30,
                    ),
                  if (state is Update_Data_Loading) const LinearProgressIndicator(),
                
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        fit: StackFit.loose,
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 240,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: cubit.backgroundImagePath != null
                                  ? Image.network(
                                      cubit.backgroundImagePath!,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      cubit.gottenData!.background_image,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          // SizedBox(height: 10,),
                          Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: const Color(0xffFF7F50),
                                  borderRadius: BorderRadius.circular(20)),
                              child: IconButton(
                                onPressed: () async {
                                  showDialog(
                                    useSafeArea: true,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // isCamera = true;
                                              cubit.PicKBackgroundimage(
                                                  isCamera: true);
                                              Navigator.pop(context);
                                              // print(isCamera);
                                              // Handle camera button press here
                                            },
                                            child: const Text('Camera'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // isCamera = false;

                                              cubit.PicKBackgroundimage(
                                                  isCamera: false);
                                              Navigator.pop(context);
                                              // print(isCamera);
                                              // Handle photo library button press here
                                            },
                                            child: const Text('Gallery'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // Handle cancel button press here
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  // print(i
                                  cubit.UploadImage(
                                    image_file: cubit.backgroundImage!,
                                    isProfile: false,
                                    // path: cubit.backgroundImage!.path
                                  );
                                },
                                icon: const Icon(
                                  IconlyBroken.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ))
                        ],
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 52,
                            child: CircleAvatar(
                              backgroundImage: cubit.profileImagePath != null
                                  ? NetworkImage(cubit.profileImagePath!)
                                  : NetworkImage(
                                      cubit.gottenData!.profile_image,
                                    ),
                              radius: 50,
                            ),
                          ),
                          Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: const Color(0xffFF7F50),
                                  borderRadius: BorderRadius.circular(20)),
                              child: IconButton(
                                onPressed: () async {
                                  // bool? isCamera;
                                  showDialog(
                                    useSafeArea: true,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // isCamera = true;
                                              cubit.PicKProfileimage(
                                                  isCamera: true);
                                              Navigator.pop(context);
                                              // print(isCamera);
                                              // Handle camera button press here
                                            },
                                            child: const Text('Camera'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // isCamera = false;
                                              cubit.PicKProfileimage(
                                                  isCamera: false);
                                              Navigator.pop(context);
                                              // print(isCamera);
                                              // Handle photo library button press here
                                            },
                                            child: const Text('Gallery'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // Handle cancel button press here
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  // print(isCamera);
                                  // if (cubit.profileImage == null) {
                                  //   print("Aha2");
                                  //   await cubit.UploadImage(
                                  //       image_file: cubit.profileImage,
                                  //       isProfile: true,
                                  //       path: cubit.profileImage!.path);
                                  //   print("Aha3");
                                  // }
                                },
                                icon: const Icon(
                                  IconlyBroken.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      ProfileField(
                        controller: nameController,
                        label: "Name",
                        dtaPrefIcon: IconBroken.Profile,
                        type: TextInputType.text,
                      ),
                      ProfileField(
                        controller: emailController,
                        label: "Email",
                        dtaPrefIcon: IconlyBroken.message,
                        type: TextInputType.text,
                      ),
                      ProfileField(
                        controller: phoneController,
                        label: "Phone",
                        dtaPrefIcon: IconBroken.Calling,
                        type: TextInputType.text,
                      ),
                      Container(
                        //lawo howa mesh null
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            // color: Colors.blue,
                            borderRadius: BorderRadius.circular(100)),
                        child: OutlinedButton(
                          onPressed: () {
                            cubit.Update_Data(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                backgroundImagePath: cubit.backgroundImagePath,
                                profileImagePath: cubit.profileImagePath
                                // backgroundImagePath: cubit.

                                );
                          },
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(color: Color(0xffFF7F50)),
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
