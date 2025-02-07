import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Constants/color.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Login/Cubit/Login_CubitStates.dart';
import 'package:social_test/Login/Login_Screen.dart';
import 'package:social_test/Login/Select_image.dart';
import 'package:social_test/Shared%20Prefrence/SharedPref.dart';
import 'package:social_test/Social/Social_Layout.dart';

//validation
var nameController = TextEditingController();
var passwordController = TextEditingController();
var confirmPasswordController = TextEditingController();
var emailController = TextEditingController();
var phoneController = TextEditingController();

class UserInfoo {
  late String name;
  late String email;
  late String password;
  late String phone;

  UserInfoo(
      {required this.name,
      required this.email,
      required this.password,
      required this.phone});
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var FormKey = GlobalKey<FormState>();
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    final RegExp phoneRegExp = RegExp(
      r'^\+?(\d{1,4})?[-.\s]?(\(?\d{1,4}\)?)?[-.\s]?\d{1,4}[-.\s]?\d{1,4}[-.\s]?\d{1,9}$',
    );
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+~`|}{[\]:;?><,./-]).{8,}$',
    );

    // bool isShowPassword = false;
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
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

          // if (state is Register_Success) {
          //   if (state.Model.status!) {
          //     AHA.SavaData(key: "token", value: state.Model.data.token).then(
          //       (value) async {
          //         Token = state.Model.data!.token;

          //         print("Token Login Success");
          //         print(state.Model.data.token);
          //         print(state.Model.data.token);
          //         print(state.Model.data.token);
          //         print(state.Model.data.token);
          //         print(state.Model.data.token);
          //         ShopCubit.get(context).Getuser();
          //         ShopCubit.get(context).DarkMode = false;
          //         // NavigatReplace(context, Imagepick());
          //         NavigatReplace(context, const Shop_Layout());
          //       },
          //     );
          //     print("///////////////////////////////////////");
          //     print("${state.Model.message}");
          //     print(state.Model.data.name);
          //     print("///////////////////////////////////////");

          //     Snake(
          //         titleWidget: Text("${state.Model.message}"),
          //         context: context,
          //         EnumColor: Messages.Success);

          //     // Fluttertoast.showToast(
          //     //   msg: "${state.Model.message}",
          //     //   toastLength: Toast.LENGTH_LONG,
          //     //   gravity: ToastGravity.BOTTOM,
          //     //   timeInSecForIosWeb: 4,
          //     //   backgroundColor: Colors.green,
          //     //   textColor: Colors.white,
          //     //   fontSize: 16.0,
          //     // );
          //   } else {
          //     print("///////////////////////////////////////");
          //     print(state.Model!.message);
          //     print("///////////////////////////////////////");
          //     Snake(
          //         titleWidget: Text("${state.Model.message}"),
          //         context: context,
          //         EnumColor: Messages.Error);

          //     // Fluttertoast.showToast(
          //     //   msg: state.Model.message,
          //     //   toastLength: Toast.LENGTH_LONG,
          //     //   gravity: ToastGravity.BOTTOM,
          //     //   timeInSecForIosWeb: 4,
          //     //   backgroundColor: Colors.red,
          //     //   textColor: Colors.white,
          //     //   fontSize: 16.0,
          //     //  K );
          //   }
          // }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);

          return Scaffold(
            // appBar: AppBar(),
            body: Container(
              padding: const EdgeInsets.all(8),
              color: PreDom2,
              child: Center(
                  child: Container(
                padding: const EdgeInsets.all(20),
                // width: double.maxFinite,
                // width: 3,
                height: 700,
                decoration: BoxDecoration(
                    color: Dom, borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView(
                  child: Form(
                    key: FormKey,
                    child: Column(
                      children: [
                        Text(
                          "SIGN UP",
                          style: TextStyle(
                              letterSpacing: 3,
                              color: Additional2,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DefaultForm(
                            validateor: (value) {
                              if (value!.isEmpty) {
                                return "Field cannot be empty";
                              } else {
                                return null; // Form is valid.
                              }
                            },
                            label: "Name",
                            controller: nameController),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultForm(
                            validateor: (value) {
                              if (value!.isEmpty) {
                                return "Field cannot be empty";
                              }
                              if (!emailRegExp.hasMatch(value)) {
                                return "Invalid email format";
                              } else {
                                return null; // Form is valid.
                              }
                            },
                            label: "Email",
                            controller: emailController),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultForm(
                            validateor: (Value) {
                              /*لازم نرتيرن نال ف الأخر؟ */
                              if (Value!.isEmpty)
                                return "Field cannot be empty";
                              else if (!phoneRegExp.hasMatch(Value)) {
                                return "Invalid phone number format";
                              } else {
                                return null; // Form is valid.
                              }
                            },
                            label: "Phone",
                            controller: phoneController),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultForm(
                            validateor: (Value) {
                              if (Value!.isEmpty) {
                                return "Field cannot be empty";
                              } else if (!passwordRegExp.hasMatch(Value)) {
                                return "Should be at least 8 characters,mix of letters,numbers,and special characters.";
                              } else {
                                return null; // Form is valid.
                              }
                            },
                            label: "Password",
                            controller: passwordController,
                            Obscure: true),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultForm(
                            validateor: (Value) {
                              if (Value!.isEmpty) {
                                return "Field cannot be empty";
                              } else if (Value != passwordController.text) {
                                return "Passwords doesen't matched";
                              } else {
                                return null; // Form is valid.
                              }
                            },
                            label: "Confirm Password",
                            controller: confirmPasswordController,
                            Obscure: true),
                        const SizedBox(
                          height: 15,
                        ),
                        state is Loading
                            ? const CircularProgressIndicator()
                            : DefaultButton(
                                ButtonFunc: () {
                                  if (FormKey.currentState!.validate()) {
                                    UserInfoo userInfo = UserInfoo(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text);

                                    NavigatReplace(context,
                                        SelectImage(userInfo: userInfo));
                                    // cubit.SendRegister(
                                    //     name: nameController.text,
                                    //     phone: phoneController.text,
                                    //     email: emailController.text,
                                    //     password: passwordController.text);Mahة
                                  }
                                },
                                ButtonWidth: 300,
                                isText: true,
                                Title: "NEXT"),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            DefaultTextButton(
                              onPressed: () =>
                                  NavigatReplace(context, const LoginScreen()),
                              text: "Login",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ),
          );
        },
      ),
    );
  }
}
