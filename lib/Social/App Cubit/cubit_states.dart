import '../../Models/PostModel.dart';

abstract class SocialStates {}

class Initial extends SocialStates {}

class Bottom_Navigation_Bar extends SocialStates {}

class Post_Image_Upload_Success extends SocialStates {}

class Post_Image_Upload_Failure extends SocialStates {}

class Post_image_Success extends SocialStates {}

class Post_image_Failure extends SocialStates {}

class Upload_Post_Success extends SocialStates {}

class Upload_Post_Failure extends SocialStates {}

class Create_Post_In_Progress extends SocialStates {}

class Get_Posts_Success extends SocialStates {}

class Get_Posts_Failure extends SocialStates {}

class Get_Users_Success extends SocialStates {}

class Get_Users_Failure extends SocialStates {}

class Get_Users_Loading extends SocialStates {}

class AppLoading extends SocialStates {}

class Like_Posts_Success extends SocialStates {}

class Like_Posts_Failure extends SocialStates {}

class Comments_Posts_Success extends SocialStates {}

class Comments_Posts_Failure extends SocialStates {}

class Send_Message_Success extends SocialStates {}

class Send_Message_Failure extends SocialStates {}

class Get_Messages_Success extends SocialStates {}

class Get_Messages_Loading extends SocialStates {}

class Add_Comment_Success extends SocialStates {}

class Add_Comment_Failure extends SocialStates {}

class Get_Comments_Success extends SocialStates {}

class Get_Comments_Loading extends SocialStates {}

class Update_Comment_Success extends SocialStates {}

class Edit_Post_Success extends SocialStates {}

class Edit_Post_Failure extends SocialStates {}

class Loadin_Edit extends SocialStates {}

class Delete_Post_Success extends SocialStates {}

class Delete_Post_Failure extends SocialStates {}

class Add_Report_Success extends SocialStates {}

class Add_Report_Failure extends SocialStates {}

class Get_Reports_Success extends SocialStates {}

class Get_Reports_Loading extends SocialStates {}

class Get_Reported_Post extends SocialStates {
final  Postmodel post;

  Get_Reported_Post(this.post);
}
class Get_Reported_Post_Failure extends SocialStates {}

class Get_Reports_Failure extends SocialStates {}

class Message_Image_Success extends SocialStates{}

class Message_Image_Failure extends SocialStates{}

class Show_Message_Time extends SocialStates{}

class Hide_Message_Time extends SocialStates{}

class Get_Last_Message_Success extends SocialStates{}

class Get_Last_Message_Loading extends SocialStates{}

class Get_Last_Message_Failure extends SocialStates{}
class Send_Password_Success extends SocialStates{}

class Send_Password_Failure extends SocialStates{}
class Change_Mode extends SocialStates{

  
}



