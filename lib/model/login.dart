class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    return Login(
      code: obj['code'],
      status: obj['status'],
      token: obj['data'] != null ? obj['data']['token'] : null,
      userID: obj['data'] != null && obj['data']['user'] != null
          ? int.tryParse(obj['data']['user']['id'].toString())
          : null,
      userEmail: obj['data'] != null && obj['data']['user'] != null
          ? obj['data']['user']['email']
          : null,
    );
  }
}