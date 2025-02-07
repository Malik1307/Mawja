

class CommentModel {
  // int postComments = 0;
  late String name;
  late String uId;
  //  String? image;
   late String profileImage;
  late String commentTime;
  late String comment;
  late String commentId;
    int commentLikes=0;


  CommentModel({
    required this.name,
    required this.uId,
    //  this.image,
    required this.commentTime,
    required this.profileImage,
    required this.comment,
    required this.commentId,
  });

  CommentModel.fromJson(Map<String, dynamic> Model) {
    name = Model['name'];
    uId = Model['uId'];
    // image = Model['image'] ?? "";
    commentTime = Model['commentTime'];
    profileImage = Model['profileImage'];
    comment = Model['comment'];
    commentId = Model['commentId'];
    commentLikes = Model['commentLikes'];
    // postLikes = Model['postLikes'];

  } 

  Map<String, dynamic> SendData() {
    return {
      'name': name,
      'uId': uId,
      // 'image': image??"",
      'profileImage': profileImage,
      'commentTime': commentTime,
      'comment': comment,
      'commentId': commentId,
      'commentLikes': commentLikes,
      // 'postLikes': postLikes,
    };
  }
}
