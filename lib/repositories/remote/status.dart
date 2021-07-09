class Status {
  bool isSuccess = true;
  String message = "";

  Status(this.isSuccess, this.message);

  Status.fromJson(Map<String, dynamic> map) {
    this.isSuccess = map["isSuccess"];
    this.message = map["message"];
  }
}
