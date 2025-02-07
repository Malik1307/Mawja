class Postmodel {
  late String name;
  late String postId;
  late String uID;
  late String profile_image;
  late String post_time;
  late String description;
  String? post_image;
  int postLikes=0;
  int postComments=0;

  Postmodel(
      {required this.name,
      required this.uID,
      required this.postId,
      required this.profile_image,
      required this.post_time,
      required this.description,
      this.post_image});

  Postmodel.fromJson(Map<String, dynamic> Model) {
    name = Model['name'];
    uID = Model['uID'];
    postId = Model['postId'];
    profile_image = Model['profile_image'];
    post_time = Model['post_time'];
    description = Model['description'];
    post_image = Model['post_image'];
    postLikes = Model['postLikes'];
    postComments = Model['postComments'];
  }

  Map<String, dynamic> SendData() {
    return {
      'name': name,
      'uID': uID,
      'profile_image': profile_image,
      'post_time': post_time,
      'description': description,
      "post_image" : post_image,
      "postLikes" : postLikes,
      "postComments" : postComments,
      "postId" : postId
    };
  }
}


