import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Login/Cubit/Login_Cubit.dart';
import 'package:social_test/Models/PostModel.dart';
import 'package:social_test/Models/UserModel.dart';
import 'package:social_test/Models/chat_model.dart';
import 'package:social_test/Models/commen_model.dart';
import 'package:social_test/Models/report_mode.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/Social/Social_Layout.dart';
import 'package:social_test/main.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(Initial());

  static SocialCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  void BottomNavigation(int index, context) {
    currentIndex = index;
    if (index == 1) getAllUsers();
    if (index == 0) Navigat(context, Social_Layout());
    // if (index == 0) LoginCubit.get(context).GetData();

    emit(Bottom_Navigation_Bar());
  }

  var picker = ImagePicker();
  File? PostImage;
  String? PostImagepath;
  // File? messegeImage;
  // String? messegeImagepath;

  // void messegeImagePicker() async {
  //   var tempCommentImage = await picker.pickImage(source: ImageSource.gallery);
  //   if (tempCommentImage != null) {
  //     messegeImage = File(tempCommentImage.path);
  //     emit(Message_Image_Success());
  //   } else
  //     emit(Message_Image_Failure());
  // }

  getPostimage() async {
    var tempPostImage = await picker.pickImage(source: ImageSource.gallery);
    if (tempPostImage != null) {
      PostImage = File(tempPostImage.path);
      emit(Post_image_Success());
    } else
      emit(Post_image_Failure());
  }

  UploadPostImage() async {
    //
//Null

    if (PostImage == null) {
      print("Mahmoud 3abeet");
    }

    await FirebaseStorage.instance
        .ref()
        .child("posts/${Uri.file(PostImage!.path).pathSegments.last}")
        .putFile(PostImage!)
        .then(
      (val) async {
        PostImagepath = await val.ref.getDownloadURL();
        emit(Post_Image_Upload_Success());
      },
    ).catchError((errror) {
      emit(Post_Image_Upload_Failure());
    });
  }

  List<Postmodel>? ListPostModel = [];

  // void filPostId() {
  //   emit(AppLoading());

  //   FirebaseFirestore.instance.collection("posts").doc()
  // }

  void GetPostsData() {
    emit(AppLoading());
    ListPostModel = [];
    FirebaseFirestore.instance
        .collection("posts")
        .orderBy("post_time", descending: true)
        .snapshots()
        .listen(
      (onData) {
        for (var element in onData.docs) {
          ListPostModel!.add(Postmodel.fromJson(element.data()));
        }
        emit(Get_Posts_Success());
      },
    );
  }

  Future<void> createPost(
    context, {
    required String description,
  }) async {
    print("Auth uId: ${FirebaseAuth.instance.currentUser!.uid}");
    print("Model uId: ${LoginCubit.get(context).gottenData!.uID}");

    // Emit a state indicating the post creation process has started
    emit(Create_Post_In_Progress());

    Postmodel postmodel;

    // If there's an image, upload it first
    if (PostImage != null) {
      print("Uploading image...");
      await UploadPostImage(); // Wait for image upload to complete
      print("Image upload complete.");
    }

    // Create the post after the image upload is done or if there's no image
    if (PostImage == null || PostImagepath != null) {
      print("Creating post...");
      String postId = FirebaseFirestore.instance.collection("posts").doc().id;
      postmodel = Postmodel(
        postId: postId,
        uID: LoginCubit.get(context).gottenData!.uID,
        profile_image: LoginCubit.get(context).gottenData!.profile_image,
        post_time: DateFormat("y-M-d h:mm a").format(DateTime.now()).toString(),
        name: LoginCubit.get(context).gottenData!.name,
        description: description,
        post_image: PostImagepath ?? "",
      );

      try {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .set(postmodel.SendData());

        print("Post creation successful.");
        emit(Upload_Post_Success());
      } catch (error) {
        print("Post creation failed: $error");
        emit(Upload_Post_Failure());
      }
    } else {
      if (PostImagepath == null) print("path is null");
      print("Image path is null. Post creation aborted.");
      emit(Upload_Post_Failure());
    }
  }

  void likePost(String postId) async {
    bool isLiked = (await FirebaseFirestore.instance
                .collection("posts")
                .doc(postId)
                .collection("likes")
                .doc(uID)
                .get())
            .data()?['like'] ??
        false;

    int currentLikes =
        (await FirebaseFirestore.instance.collection("posts").doc(postId).get())
                .data()?['postLikes'] ??
            0;
    print(currentLikes);
    print("like:$isLiked");
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(uID)
        .set({"like": !isLiked}).then(
      (value) {
        if (!isLiked) {
          FirebaseFirestore.instance
              .collection("posts")
              .doc(postId)
              .set({"postLikes": ++currentLikes}, SetOptions(merge: true));
        } else {
          FirebaseFirestore.instance
              .collection("posts")
              .doc(postId)
              .set({"postLikes": --currentLikes}, SetOptions(merge: true));
        }
        // print(object)

        emit(Like_Posts_Success());
      },
    ).catchError((error) {
      print(error.toString());
      emit(Like_Posts_Failure());
    });

    GetPostsData();
  }

  // Future<bool>amILikedThis(postId) async{
  // return ( await FirebaseFirestore.instance
  //           .collection("posts")
  //           .doc(postId)
  //           .collection("likes")
  //           .doc(uID)
  //           .get())
  //           .data()?["like"] ??
  //       false;
  // }
  List<UserModel> users = [];
  getAllUsers() {
    emit(Get_Users_Loading());
    users = [];

    FirebaseFirestore.instance.collection("Users").get().then(
      (value) {
        for (var element in value.docs) {
          if (element.id != uID) users.add(UserModel.ExtraData(element.data()));
        }

        emit(Get_Users_Success());
      },
    ).catchError((error) {
      print(error.toString());
      emit(Get_Users_Failure());
    });
  }

  sendMessage(
    context, {
    required String receiverImage,
    required String receiverUid,
    required String text,
    // String ?image
  }) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String messageTime =
        DateFormat('MMMM d, yyyy, h:mm a').format(DateTime.now());
    if (LoginCubit.get(context).gottenData!.profile_image == null) {
      print("null profuk");
    }
// image= await FirebaseStorage.instance
//         .ref()
//         .child("posts/${Uri.file(messegeImage!.path).pathSegments.last}")
//         .putFile(messegeImage!)
//         .then(
//       (val) async {
//         messegeImagepath = await val.ref.getDownloadURL();
//         emit(Message_Image_Success());
//       },
//     ).catchError((errror) {
//       emit(Message_Image_Failure());
//     })??"";
    ChatModel modelChat = ChatModel(
        messageComparingTime: formattedDate,
        senderImage: LoginCubit.get(context).gottenData!.profile_image,
        messageTime: messageTime,
        receiverImage: receiverImage,
        receiverUid: receiverUid,
// image: messegeImagepath??"",
        senderUid: uID!,
        text: text);

    FirebaseFirestore.instance
        .collection("Users")
        .doc(uID)
        .collection("Chats")
        .doc(receiverUid)
        .collection("Messages")
        .add(modelChat.SendData())
        .then(
      (value) {
        emit(Send_Message_Success());
      },
    ).catchError((erroor) => emit(Send_Message_Failure()));
    FirebaseFirestore.instance
        .collection("Users")
        .doc(receiverUid)
        .collection("Chats")
        .doc(uID)
        .collection("Messages")
        .add(modelChat.SendData())
        .then(
      (value) {
        emit(Send_Message_Success());
      },
    ).catchError((erroor) => emit(Send_Message_Failure()));
  }

  List<ChatModel> messages = [];
  int? isShownMessageTime;
  List<bool> isEnabled = [];

  showMessegeTime(index) async {
    if (isEnabled.isEmpty) print("sdfkmfkldsmdklmdf");
    print("${isEnabled.length}sdfnmkln");

    if (!isEnabled[index]) {
      // Reset all other indices
      // for (int i = 0; i < isEnabled.length; i++) isEnabled[i] = false;
      isShownMessageTime = index;
      isEnabled[index] = true;
      emit(Show_Message_Time());
      print(isEnabled);
    } else {
      isShownMessageTime = null;
      isEnabled[index] = false;
      emit(Hide_Message_Time());
    }
  }

  String? lastMessege;
  getMesseges({required String receiverUid}) {
    emit(Get_Messages_Loading());
    FirebaseFirestore.instance
        .collection("Users")
        .doc(uID)
        .collection("Chats")
        .doc(receiverUid)
        .collection("Messages")
        .orderBy("messageComparingTime", descending: false)
        .snapshots()
        .listen((onData) {
      messages = [];
      isEnabled = [];
      for (var element in onData.docs) {
        messages.add(ChatModel.fromJson(element.data()));
        isEnabled.add(false);
      }
      emit(Get_Messages_Success());
    });
  }

// var loginCubit=LoginCubit.get(context);
  List<CommentModel> comments = [];
  addComment(
    context, {
    required String postId,
    required String comment,
    required String profileImage,
    // required String name,
    // required String image,
  }) {
    String messageTime =
        DateFormat('dd MMMM yyyy, h:mm a').format(DateTime.now());
    String commentId = FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc()
        .id;
    late int postComments;

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .get()
        .then((val) {
      postComments = val.data()?["postComments"];
    });

    CommentModel modelComment = CommentModel(
      profileImage: profileImage,
      comment: comment,
      commentId: commentId,
      commentTime: messageTime,
      name: LoginCubit.get(context).gottenData!.name,
      uId: uID!,
      // image: image
    );

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .set(modelComment.SendData())
        .then(
      (value) async {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .set({"postComments": ++postComments}, SetOptions(merge: true));
        emit(Add_Comment_Success());
      },
    ).catchError((erro) => emit(Add_Comment_Failure()));
  }

  void getComments({required String postId}) {
    emit(Get_Comments_Loading());
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .orderBy("commentTime")
        .snapshots()
        .listen((data) {
      comments = [];
      for (var element in data.docs) {
        comments.add(CommentModel.fromJson(element.data()));
      }
      emit(Get_Comments_Success());
    });
  }

  editPost(postId, newDescription) {
    // emit(Loadin_Edit());
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .set({"description": newDescription}, SetOptions(merge: true)).then(
      (value) async {
        ListPostModel = null;
        // emit(Loadin_Edit());

        emit(Edit_Post_Success());
        if (ListPostModel == null) print("null list post");

        // GetPostsData();
      },
    ).catchError((error) => emit(Edit_Post_Failure()));
  }

  deletePost(postId) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .delete()
        .then((value) => emit(Delete_Post_Success()))
        .catchError((erro) => emit(Delete_Post_Failure()));
  }

  reportPost({
    required String postId,
    required String authorId,
    required String reportText,
  }) {
    String reportTime =
        DateFormat('dd MMMM yyyy, h:mm a').format(DateTime.now());
    ReportMode report = ReportMode(
        authorId: authorId,
        postId: postId,
        report: reportText,
        reportTime: reportTime);

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("reports")
        .add(report.sendData())
        .then(
          (value) => emit(Add_Report_Success()),
        )
        .catchError((error) => emit(Add_Report_Failure()));
  }

  List<ReportMode> reports = [];
  getReports() {
    emit(Get_Reports_Loading());
    reports = [];

    FirebaseFirestore.instance.collection("posts").get().then(
      (postsSnapshot) {
        List<Future<void>> commentFutures = [];

        for (var postDoc in postsSnapshot.docs) {
          if (postDoc.get("uID") == uID) {
            commentFutures.add(
              postDoc.reference
                  .collection("reports")
                  .get()
                  .then((commentsSnapshot) {
                for (var reportDoc in commentsSnapshot.docs) {
                  reports.add(ReportMode.fromJson(reportDoc.data()));
                }
              }),
            );
          }
        }

        // Wait for all comment-fetching operations to complete
        Future.wait(commentFutures).then((_) {
          emit(Get_Reports_Success());
        }).catchError((error) {
          emit(Get_Reports_Failure());
        });
      },
    ).catchError((error) {
      emit(Get_Reports_Failure());
    });
  }

  Postmodel? reportedPost;
  void getReportedPost(String postId) {
    // print(postId + "post id");

    // Iterate through the posts to find the one with the matching ID
    for (int i = 0; i < ListPostModel!.length; i++) {
      print("${ListPostModel![i].postId}post post id");
      if (ListPostModel![i].postId == postId) {
        reportedPost = ListPostModel![i];
        break;
      }
    }

    if (reportedPost != null) {
      emit(Get_Reported_Post(reportedPost!));
    } else {
      emit(Get_Reported_Post_Failure()); // In case the post isn't found
    }
  }

  // Future<void> getLastMessages() async {
  //   emit(Get_Comments_Loading()); // Start loading state
  //   List lastMessages = [];

  //   try {
  //     // Validate uID
  //     if (uID == null || uID!.isEmpty) {
  //       throw Exception("Invalid uID");
  //     }

  //     // Fetch users from the "Users" collection
  //     var usersSnapshot =
  //         await FirebaseFirestore.instance.collection("Users").get();
  //     int currentUsers = usersSnapshot.size;

  //     // Debug: Log current users
  //     print("$currentUsers Current Users");

  //     // Get the user's document reference
  //     var userDoc =
  //         await FirebaseFirestore.instance.collection("Users").doc(uID).get();

  //     // Ensure the user document exists
  //     if (!userDoc.exists) {
  //       throw Exception("User document does not exist");
  //     }

  //     // Fetch all chat references for the user
  //     var chatsSnapshot = await userDoc.reference.collection("Chats").get();

  //     // Handle case where no chats exist for the user
  //     if (chatsSnapshot.docs.isEmpty) {
  //       return;
  //     }

  //     // Fetch the latest message from each chat in parallel
  //     var messageFutures = chatsSnapshot.docs.map((chatDoc) async {
  //       var messagesSnapshot = await chatDoc.reference
  //           .collection("Messages")
  //           .orderBy("messageTime", descending: true) // Order by latest message
  //           .limit(1)
  //           .get();

  //       if (messagesSnapshot.docs.isNotEmpty) {
  //         return messagesSnapshot.docs.first.get("text");
  //       } else {
  //         return "No messages found"; // Fallback if no messages exist
  //       }
  //     }).toList();

  //     // Wait for all messages to be fetched
  //     lastMessages = await Future.wait(messageFutures.toList());

  //     // Remove null or invalid messages
  //     lastMessages.removeWhere((message) => message == null);

  //     // Emit success state and log the last messages
  //     emit(Get_Last_Message_Success());
  //     print("Last messages: $lastMessages");
  //   } catch (error) {
  //     // Emit failure state and log the error
  //     emit(Get_Last_Message_Failure());
  //     print("Error fetching messages: $error");
  //   }

  //   print(lastMessages.toString());
  // }
  forgotPassword(email) async{
  try {
  await  FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  
  emit(Send_Password_Success());
} on Exception catch (e) {
  emit(Send_Password_Failure());
}
  }
}
