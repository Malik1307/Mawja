class UserModel {
  late String name;
  late String email;
  late String phone;
  late String uID;
  late String profile_image;
  late String background_image;
  late bool isEmailVerified;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.uID,
      required this.isEmailVerified,
      required this.profile_image,
      required this.background_image});

  UserModel.ExtraData(Map<String, dynamic> Model) {
    name = Model['name'];
    email = Model['email'];
    phone = Model['phone'];
    uID = Model['uID'];
    profile_image = Model['profile_image'];
    background_image = Model['background_image'];

    isEmailVerified = Model['isEmailVerified'];
  }
  Map<String, dynamic> SendData() {
    return {
      "name": name,
      'email': email,
      'phone': phone,
      'uID': uID,
      "profile_image": profile_image,
      "background_image": background_image,
      'isEmailVerified': isEmailVerified
    }; //How To Send this Id
  }

  //   Model['name'] = name;
  //   Model['email'] = email;
  //   Model['phone'] = phone;
  //   Model['uID'] = uID; //How To Send this Id

  //   return Model;
  // }
}
