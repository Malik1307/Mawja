import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Login/Cubit/Login_CubitStates.dart';
import 'package:social_test/Login/Register_Scree.dart';
import 'package:social_test/Shared%20Prefrence/SharedPref.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/Social/Social_Layout.dart';
import 'package:social_test/main.dart';

import '../Constants/color.dart';
// import 'package:flutter/services.dart';

//جزئية ال فلديات ازودها

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
    var EmailController = TextEditingController();
    var PassController = TextEditingController();
    var KeyForm = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {

        if(state is Send_Password_Success)
          Snake(
              titleWidget: const Text("Please check yout inbox"),
              context: context,
              EnumColor: Messages.Success);
if(state is Send_Message_Failure)
          Snake(
              titleWidget: const Text("Please contatct with us at +201064189695"),
              context: context,
              EnumColor: Messages.Error);


        if (state is Login_Success) {
          Cache.WriteData(key: "uId", value: state.uid);

          Snake(
              titleWidget: const Text("Successfuly Logined"),
              context: context,
              EnumColor: Messages.Success);
          uID = FirebaseAuth.instance.currentUser!.uid;
          print(uID);
          NavigatReplace(context, const Social_Layout());
          // SocialCubit.get(context).GetPostsData();
          // LoginCubit.get(context).GetData();
        }
        if (state is Login_Failed)
          Snake(
              titleWidget: const Text("Login Failed"),
              context: context,
              EnumColor: Messages.Error);
      }, builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
        return Scaffold(
          // appBar: AppBar(),
          body: Container(
            padding: const EdgeInsets.all(8),
            color: PreDom2,
            child: Center(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(20),
              // width: double.maxFinite,
              height: 500,
              child: Form(
                key: KeyForm,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "LOGIN",
                            // "LOGIN",
                            style: TextStyle(
                                letterSpacing: 3,
                                color: Additional2,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          DefaultForm(
                            label: "Email",
                            dtaPrefIcon: Icons.email,
                            controller: EmailController,
                            type: TextInputType.text,
                            validateor: (value) {
                              if (value!.isEmpty) {
                                return "Please enter an email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          DefaultForm(
                              onFieldSubmitted: (value) {
                                if (KeyForm.currentState!.validate()) {
                                  cubit.Login(
                                      email: EmailController.text,
                                      password: PassController.text);
                                }
                              },
                              controller: PassController,
                              type: TextInputType.visiblePassword,
                              validateor: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter a password";
                                }
                                return null;
                              },
                              Obscure: cubit.HiddenPassword,
                              label: "Password",
                              suff_func: () {
                                cubit.TogglePassword();
                              },
                              dtaPrefIcon: Icons.lock,
                              dtaSufIcon: Icon(
                                Icons.remove_red_eye,
                                color:
                                    cubit.HiddenPassword ? null : Colors.blue,
                              )),
                          const SizedBox(
                            height: 40,
                          ),
                          state is Loading
                              ? const Center(child: CircularProgressIndicator())
                              : DefaultButton(
                                  ButtonFunc: () {
                                    if (KeyForm.currentState!.validate()) {
                                      cubit.Login(
                                          email: EmailController.text,
                                          password: PassController.text);
                                    }
                                  },
                                  ButtonWidth: 300,
                                  isText: true,
                                  Title: "Login"),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextButton(
                            onPressed: () {

showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Forgot Password'),
                                      content: Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: emailController,
                                              keyboardType:TextInputType.emailAddress,
                                              decoration: const InputDecoration(
                                                labelText: 'Enter your email',
                                              ),
                                            
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              String email =
                                                  emailController.text.trim();
                                              SocialCubit.get(context).forgotPassword(email);
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: const Text('Submit'),
                                        ),
                                      ],
                                    ),
                                  );
                                
                            },
                            text: "Forgot Password",
                          ),
                        ),
                        // const Spacer(),

                        const Text("Not a member yet ?"),
                        DefaultTextButton(
                          onPressed: () =>
                              NavigatReplace(context, const RegisterScreen()),
                          text: "Sign up",
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )),
          ),
        );
        // }, listener: (context, state) {
        //   if (state is Login_Success) if (state.Model!.status) {
        //     AHA.SavaData(key: "token", value: state.Model.data.token).then(
        //       (value) async {
        //         Token = state.Model.data.token;

        //         print("Tocken Login Success");
        //         print(state.Model.data.token);
        //         print(state.Model.data.token);
        //         print(state.Model.data.token);
        //         print(state.Model.data.token);
        //         print(state.Model.data.token);
        //         ShopCubit.get(context).Getuser();
        //         ShopCubit.get(context).DarkMode = false;

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
      }),
    );
  }
}
