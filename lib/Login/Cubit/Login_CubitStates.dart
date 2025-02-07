abstract class LoginStates {}

class initial extends LoginStates {}

class Toggle_Password extends LoginStates {}

class Loading extends LoginStates {}

class Login_Success extends LoginStates {
  // var Model;
  String uid;

  Login_Success(this.uid);
}

class Login_Failed extends LoginStates {
  // late String Error;
  // Login_Failed(String Error) {
  //   this.Error = Error;
  // }
}

class Save_Skipped extends LoginStates {}

class Register_Failed extends LoginStates {
  final String Error;
  Register_Failed(this.Error);
}

class User_Created_Success extends LoginStates {
  String uid;

  User_Created_Success(this.uid);
}

class User_Created_Failed extends LoginStates {
  final String Error;
  User_Created_Failed(this.Error);
}

class Get_User_Data_Success extends LoginStates {}

class Get_User_Data_Failed extends LoginStates {}

class Profile_image_Success extends LoginStates{}

class Profile_image_Failed extends LoginStates{}

class Background_image_Success extends LoginStates{}

class Background_image_Failed extends LoginStates{}

class Upload_Image_Success extends LoginStates{}

class Upload_Image_Failed extends LoginStates{}

class Get_Url_Success extends LoginStates{}

class Get_Url_Failed extends LoginStates{}

class Update_Data_Success extends LoginStates{}

class Update_Data_Loading extends LoginStates{}

class Update_Data_Failed extends LoginStates{}

class Loading_Image extends LoginStates{}


