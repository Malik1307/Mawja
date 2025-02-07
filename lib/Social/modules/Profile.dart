import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:iconly/iconly.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Login/Cubit/Login_CubitStates.dart';
import 'package:social_test/Social/modules/Edit_Profile.dart';
import 'package:social_test/main.dart';
//delete in many places

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var width = Width(context);
    var height = Height(context);
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocProvider(
      create: (context) => LoginCubit()..GetData(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          if (cubit.gottenData != null) {//جاااااامد
            nameController.text = LoginCubit.get(context).gottenData!.name;
            phoneController.text = LoginCubit.get(context).gottenData!.phone;
            emailController.text = LoginCubit.get(context).gottenData!.email;
          } else
            print("data is null");
          return state is Loading
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()))
              : Scaffold(
                  appBar: AppBar(
                    actions: [
                      DefaultTextButton(
                          onPressed: () {
                            NavigatReplace(context, const Edit_Profile());
                          },
                          text: "Edit Profile",
                          color: const Color.fromARGB(255, 7, 106, 186))
                    ],
                    leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(IconlyBroken.arrow_left_2)),
                  ),
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 240,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: cubit.backgroundImagePath != null
                                    ? Image.network(
                                        cubit.backgroundImagePath!,
                                        height: 200,
                                        width: double.infinity,
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
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "101 Followers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "101 Followers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "101 Followers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: [
                            ProfileField(
                              enabled: false,
                              controller: nameController,
                              label: "Name",
                              dtaPrefIcon: IconBroken.Profile,
                              type: TextInputType.text,
                            ),
                            ProfileField(
                              enabled: false,
                              controller: emailController,
                              label: "Email",
                              dtaPrefIcon: IconlyBroken.message,
                              type: TextInputType.text,
                            ),
                            ProfileField(
                              enabled: false,
                              controller: phoneController,
                              label: "Phone",
                              dtaPrefIcon: IconBroken.Calling,
                              type: TextInputType.text,
                            ),
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

Widget ProfileField(
    {required String label,
    controller,
    Obscure = false,
    required IconData dtaPrefIcon,
    bool enabled = true,
    dtaSufIcon,
    isDark = false,
    onChanged,
    onFieldSubmitted,
    suff_func,
    required TextInputType type,
    String? Function(String?)? validator}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    child: DefaultForm(
        label: label,
        controller: controller,
        Obscure: Obscure,
        dtaPrefIcon: dtaPrefIcon,
        enabled: enabled,
        dtaSufIcon: dtaSufIcon,
        isDark: isDark,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        suff_func: suff_func,
        type: type,
        validateor: validator),
  );
}
