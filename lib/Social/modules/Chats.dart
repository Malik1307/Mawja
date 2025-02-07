import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Models/UserModel.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/Social/modules/inside_chat.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return state is Get_Users_Success
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 25,
                        ),
                    itemCount: cubit.users.length,
                    itemBuilder: (context, index) =>
                        toChatFreind(cubit.users[index], context)),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

Widget toChatFreind(UserModel user, context) {
  return GestureDetector(
    onTap: () {
      Navigat(context, InsideChat(user: user));
    },
    child: Row(
      children: [
        ClipOval(
            child: Image.network(
          user.profile_image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            "images/images9.png",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        )),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              user.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            const Text("Last Message")
            // const SizedBox(
            //   height: 0,
            // ),
          ]),
        )
      ],
    ),
  );
}
