import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_test/Login/Cubit/Login_CubitStates.dart';
import 'package:social_test/Models/UserModel.dart';
import 'package:social_test/Social/modules/Profile.dart';
import 'package:social_test/main.dart';

//uid null?
class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(initial());
  static LoginCubit get(k) => BlocProvider.of(k);
  bool HiddenPassword = true;

  UserCreate(
      {required String name,
      required String email,
      required String phone,
      required String uID,
      required String profile_image,
      bool isEmailVerfied = false}) {
    // User Model=  User(name:name,email:email,phone:phone);
    UserModel model = UserModel(
        background_image:
            "https://faroutmagazine.co.uk/static/uploads/1/2023/03/A-Clockwork-Orange-Stanley-Kubrick-Malcolm-McDowell-1971-Far-Out-Magazine-1140x855.jpg",
        profile_image: profile_image != ""
            ? profile_image
            : "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg",
        name: name,
        email: email,
        phone: phone,
        uID: uID,
        isEmailVerified: isEmailVerfied);

    FirebaseFirestore.instance
        .collection("Users")
        .doc(uID)
        .set(model.SendData())
        .then(
      (value) {
        emit(User_Created_Success(uID));
      },
    ).catchError((error) {
      print("FireStore Error$error");
      emit(User_Created_Failed(error.toString()));
    });
  }

  UserModel? gottenData;

  Future? SendRegister(
      {required String email,
      required String password,
      required String phone,
      required String profileImage,
      required String name}) {
    emit(Loading());
    // if(p)
    print("Register" + profileImage);
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        // emit(Register_Success());
        UserCreate(
            profile_image: profileImage,
            email: email,
            phone: phone,
            name: name,
            uID: value.user!.uid,
            isEmailVerfied: value.user!.emailVerified ?? false);
      },
    ).catchError((err) {
      print("Register Error$err");
      emit(Register_Failed(err.toString()));
    });
    return null;

    // try {
    //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //     if (user == null) {
    //       print('User is currently signed out!');
    //     } else {
    //       print('User is signed in!');
    //     }
    //   });
    // } catch (e) {

    // }
  }

  // void saveskipped() {
  //   FinishOnBoard = AHA.readData(key: "OnBoarding")!;
  //   print("++++++++++++++++++++++++++++++++++++++++++++++");
  //   print(FinishOnBoard);
  //   print("++++++++++++++++++++++++++++++++++++++++++++++");
  //   emit(Save_Skipped());
  // }

  TogglePassword() {
    HiddenPassword = !HiddenPassword;

    emit(Toggle_Password());
  }

  void Login({required email, required password}) async {
    emit(Loading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        print(value.user!.email);
        emit(Login_Success(value.user!.uid));
      },
    ).catchError((error) {
      emit(Login_Failed());
    });
  }

  void GetData() {
    emit(Loading());
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (value) {
        gottenData = UserModel.ExtraData(value.data()!);
        // print(gottenData!.isEmailVerified);
        print(gottenData!.name);

        // print(value.data()
        emit(Get_User_Data_Success());
      },
    ).catchError((erro) {
      print(erro.toString());
      emit(Get_User_Data_Failed());
    });
    if (profileImagePath != null) print("Prifile path:${profileImagePath!}");
    if (backgroundImagePath != null) print("back path:${backgroundImagePath!}");
  }

  File? profileImage;
  File? backgroundImage;
  String? profileImagePath;
  String? backgroundImagePath;
  final picker = ImagePicker();

  Future PicKProfileimage({required bool isCamera}) async {
    print("$profileImage file");
    print("$profileImagePath path");

    var pickedFile = await picker.pickImage(
        source: !isCamera ? ImageSource.gallery : ImageSource.camera);

    if (pickedFile != null) {
      print("picked file not equal null  ");
      profileImage = File(pickedFile.path);
      print("profileImageeeeeeeeeeee$profileImage");
      emit(Profile_image_Success());
      if (profileImage != null)
        await UploadImage(
            image_file: profileImage,
            // path: profileImagePath!,
            isProfile: true);
      else
        print("profile immmmmmmmm null");
    } else
      emit(Profile_image_Failed());

    if (profileImagePath == null) print("Path Path Path is null");
    print("$profileImage file after");
    print("$profileImagePath path after");
  }

  Future UploadImage(
      {required image_file,
      // required String path,
      required bool isProfile}) async {
    //Details

    if (image_file == null) print("error on filling the image fiel");

    print("AHa");

    print("image path will be equal null");
    print("else");
    var storageRef = FirebaseStorage.instance.ref();
    var imageRef = storageRef
        .child("Users/images/${Uri.file(image_file!.path).pathSegments.last}");

    // Start uploading the file
    return imageRef.putFile(image_file).then((_) {
      // File uploaded successfully
      return imageRef.getDownloadURL(); // Get the download URL
    }).then((downloadUrl) {
      // Set the URL and emit success
      if (isProfile) {
        profileImagePath = downloadUrl;
      } else {
        backgroundImagePath = downloadUrl;
      }

      if (profileImagePath != null) {
        print("Profile path: ${profileImagePath!}");
      }
      if (backgroundImagePath != null) {
        print("Background path: ${backgroundImagePath!}");
      }

      emit(Get_Url_Success());
    }).catchError((error) {
      // Handle any errors that occur
      print("Error: $error");
      emit(Upload_Image_Failed());
    });
  }

  Future PicKBackgroundimage({required bool isCamera}) async {
    final pickedFile = await picker.pickImage(
        source: !isCamera ? ImageSource.gallery : ImageSource.camera);

    if (pickedFile != null) {
      backgroundImage = File(pickedFile.path);
      emit(Background_image_Success());
      await UploadImage(image_file: backgroundImage, isProfile: false);
    } else
      emit(Background_image_Failed());
  }

  void Update_Data({
    String? name,
    String? email,
    String? phone,
    String? uiD,
    bool? isEmailVerified,
    String? backgroundImagePath,
    String? profileImagePath,
  }) {
    emit(Update_Data_Loading());

    if (name != null) gottenData!.name = name;
    if (email != null) gottenData!.email = email;
    if (phone != null) gottenData!.phone = phone;
    if (uiD != null) gottenData!.uID = uiD;
    if (isEmailVerified != null) gottenData!.isEmailVerified = isEmailVerified;
    if (backgroundImagePath != null)
      gottenData!.background_image = backgroundImagePath;
    if (profileImagePath != null) gottenData!.profile_image = profileImagePath;
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(gottenData!.SendData(), SetOptions(merge: true))
        .then(
      (value) {
        GetData();
        print("Uid Update$uiD");
        print("Uid Update${FirebaseAuth.instance.currentUser!.uid}");
        emit(Update_Data_Success());
      },
    ).catchError((error) {
      emit(Update_Data_Failed());
    });
  }

  // void UpdateData({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String uiD,
  //   required bool isEmailVerified,
  //   required String backgroundImagePath,
  //   required String profileImagePath,

  // }) {
  //   FirebaseFirestore.instance.collection("Users").doc(uID).update();
  // }
}
