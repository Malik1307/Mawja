import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Constants/color.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Login/Cubit/Login_CubitStates.dart';
import 'package:social_test/Login/Register_Scree.dart';
import 'package:social_test/Shared%20Prefrence/SharedPref.dart';
import 'package:social_test/Social/Social_Layout.dart';

class SelectImage extends StatelessWidget {
  final UserInfoo userInfo;

  const SelectImage({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    print(userInfo.password);
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
          listener: (context, state) {
            if (state is User_Created_Success) {
            Cache.WriteData(key: "uId", value: state.uid);

            Snake(
                titleWidget: const Text("Successfully Registered"),
                context: context,
                EnumColor: Messages.Success);

            NavigatReplace(context, const Social_Layout());
            LoginCubit.get(context).GetData();
            nameController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            emailController.clear();
            phoneController.clear();
          }
          if (state is User_Created_Failed)
            Snake(
                titleWidget: Text(state.Error),
                context: context,
                EnumColor: Messages.Error);
          if (state is Register_Failed)
            Snake(
                titleWidget: Text(state.Error),
                context: context,
                EnumColor: Messages.Error);


          },
          builder: (context, state) {

            var loginCubit=LoginCubit.get(context);
            return Scaffold(
              backgroundColor: PreDom2,
            appBar: AppBar(title: const Text("Select Profile Image")),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Image picker
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: loginCubit.profileImage != null
                            ? FileImage(loginCubit.profileImage!)
                            : const AssetImage(
                                'images/default-avatar-icon-of-social-media-user-vector.jpg'),
                      ),
                      GestureDetector(
                        onTap: () {
                      // dialgoAwesome(title: title, type: type)
                      
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Select the image source"),
                                actionsAlignment:
                                    MainAxisAlignment.spaceAround,
                                actions: [
                                  OptionWidget(
                                      optionFunction: () async{
                                        loginCubit.PicKProfileimage(isCamera: true);
                                        Navigator.pop(context);
                                      },
                                      optionTitle: "Camera"),
                                  OptionWidget(
                                      optionFunction: ()async {
                                        loginCubit.PicKProfileimage(isCamera: false);
                                        Navigator.pop(context);
                                      },
                                      optionTitle: "Gallery"),
                                ],
                              );
                            },
                          );
                      
                          // Code to pick image
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Pick Image Button

                  
                  const Spacer(),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {


                        loginCubit.SendRegister(
                          
                          
                          profileImage: loginCubit.profileImagePath??"",
                            name: userInfo.name,
                            email: userInfo.email,
                            phone: userInfo.phone,
                            // photo: userInfo.phone,
                            password: userInfo.password,
                            // semester: "Two"
                            
                            
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Next", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
          }
    
  }

Widget OptionWidget({
  required VoidCallback optionFunction,
  required String optionTitle,
}) {
  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Colors.blue),
      child: MaterialButton(
        onPressed: optionFunction,
        child: Text(
          optionTitle,
          style: const TextStyle(color: Colors.white),
        ),
      ));
}
