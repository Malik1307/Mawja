import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Models/PostModel.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';

class MakeReport extends StatelessWidget {
  final Postmodel model;

  const MakeReport({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    bool firstTime = true;
    var makeReport = TextEditingController();
    return BlocConsumer<SocialCubit, SocialStates>(
      builder: (context, state) {
        return state is AppLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Report',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: formKey,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? "please fill the field" : null,
                            controller: makeReport,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'Update your post',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                firstTime = false;
                                // Add your save functionality here
                                if (formKey.currentState!.validate()) {
                                  SocialCubit.get(context).reportPost(authorId:model.uID,
                                    postId:   model.postId,reportText:  makeReport.text);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Send'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
      listener: (context, state) {
        if (state is Edit_Post_Success) {
          Snake(
              titleWidget: const Text("Edit post successfully"),
              context: context,
              EnumColor: Messages.Success);
          SocialCubit.get(context).GetPostsData();
        }
        if (state is Edit_Post_Failure)
          Snake(
              titleWidget: const Text("Changes haven't been saved"),
              context: context,
              EnumColor: Messages.Error);
      },
    );
  }
}
