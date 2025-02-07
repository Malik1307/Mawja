class ReportMode {
  late String report;

  late String authorId;
  late String postId;
  late String reportTime;

  ReportMode({
    required this.report,
    required this.authorId,
    required this.postId,
    required this.reportTime,
  });

  ReportMode.fromJson(Map<String, dynamic>  model) {
    report = model["report"];
    authorId = model["authorId"];
    postId = model["postId"];
    reportTime = model["reportTime"];
  }

  Map <String,String> sendData() {
    return {
      "report": report,
      "authorId": authorId,
      "postId": postId,
      "reportTime": reportTime,
    };
  }
}
