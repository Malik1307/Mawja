import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:social_test/Models/UserModel.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/main.dart';

class InsideChat extends StatelessWidget {
  final UserModel user;
  const InsideChat({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Builder(builder: (context) {
      SocialCubit.get(context).getMesseges(receiverUid: user.uID);

      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          var messageController = TextEditingController();
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                        child: Image.network(
                      user.profile_image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
            body: state is Get_Messages_Loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                var message = cubit.messages[index];
                                if (message.senderUid == uID)
                                  return sendedMessage(recieverUid: message.receiverUid,
                                      index: index,
                                      text: message.text,
                                      context,
                                      messegeTime: message.messageTime);

                                return receivedMessage(recieverUid: message.receiverUid,
                                    index: index,
                                    text: message.text,
                                    context,
                                    messegeTime: message.messageTime);
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                    height: 10,
                                  ),
                              itemCount: cubit.messages.length),
                        ),
                        // const Spacer(),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                // width: 1
                              )),
                          child: Row(
                            children: [
                              Expanded(
                                child: Form(
                                  key: formKey,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "fill the comment field";
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isNotEmpty)
                                        cubit.sendMessage(
                                            receiverImage: user.profile_image,
                                            receiverUid: user.uID,
                                            text: value,
                                            context);
                                    },
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20),
                                      hintText: "type your message....",
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              // IconButton(
                              //   icon: Icon(
                              //     IconBroken.Image_2,
                              //     color: Colors.blue,
                              //   ),
                              //   onPressed: () {
                              //     cubit.messegeImagePicker();
                              //   }
                              // ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                // height: 40,
                                // width: 60,
                                color: Colors.blue,
                                child: MaterialButton(
                                  minWidth: 1,
                                  onPressed: () {
                                    if (formKey.currentState!.validate())
                                      cubit.sendMessage(
                                          receiverImage: user.profile_image,
                                          receiverUid: user.uID,
                                          text: messageController.text,
                                          // image: cubit.messegeImagepath ?? "",
                                          context);
                                  },
                                  child: const Icon(
                                    IconBroken.Send,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          );
        },
      );
    });
  }
}

//time and image
Widget receivedMessage(context,
    {required String text, required String messegeTime, required int index,required String recieverUid}) {
  var cubit = SocialCubit.get(context);
  bool isEnabled = false;
  return Align(
    alignment: Alignment.topLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () =>
        cubit.showMessegeTime(index),
      
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: Text(text),
          ),
        ),
        if (cubit.isShownMessageTime == index)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(messegeTime),
          )
      ],
    ),
  );
}

Widget sendedMessage(context,
    {required String text, required String messegeTime, required int index,required recieverUid}) {
  var cubit = SocialCubit.get(context);
  return Align(
    alignment: Alignment.topRight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => cubit.showMessegeTime(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            child: Text(text),
          ),
        ),
        if (cubit.isShownMessageTime == index)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(messegeTime),
          )
      ],
    ),
  );
}
