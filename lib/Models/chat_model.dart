

class ChatModel {
  // int postComments = 0;
  late String text;
  late String senderUid;
  late String receiverUid;
  late String receiverImage;
  late String senderImage;
  late String messageTime;
  late String messageComparingTime;
  // String? image;

  ChatModel({
    required this.text,
    required this.senderUid,
    required this.receiverUid,
    required this.receiverImage,
    required this.senderImage,
    required this.messageTime,
    required this.messageComparingTime,
    //  this.image,
  });

  ChatModel.fromJson(Map<String, dynamic> Model) {
    text = Model['text'];
    senderUid = Model['senderUid'];
    receiverUid = Model['receiverUid'];
    receiverImage = Model['receiverImage'];
    senderImage = Model['senderImage'];
    messageTime = Model['messageTime'];
    // image = Model['image']??"";
  }

  Map<String, dynamic> SendData() {
    return {
      'text': text,
      'messageComparingTime': messageComparingTime,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'receiverImage': receiverImage,
      'senderImage': senderImage,
      'messageTime': messageTime,
      // 'image': image??"",
    };
  }
}
