class SocialLoginResponse {
  String? status;
  String? message;
  Data? data;

  SocialLoginResponse({this.status, this.message, this.data});

  SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? name;
  String? email;
  String? token;
  String? phoneNumber;
  String? dateOfBirth;
  String? university;
  String? province;

  Data(
      {this.userId,
      this.name,
      this.email,
      this.token,
      this.phoneNumber,
      this.dateOfBirth,
      this.university,
      this.province});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    token = json['token'];
    phoneNumber = json['phone_number'];
    dateOfBirth = json['date_of_birth'];
    university = json['university'];
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['token'] = token;
    data['phone_number'] = phoneNumber;
    data['date_of_birth'] = dateOfBirth;
    data['university'] = university;
    data['province'] = province;
    return data;
  }
}

class LoginResponse {
  String? status;
  String? message;
  String? token;
  User? user;

  LoginResponse({this.status, this.message, this.token, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? name;
  List<String>? roles;

  User({this.id, this.username, this.email, this.name, this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    name = json['name'];
    roles = json['roles'] != null ? List<String>.from(json['roles']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['name'] = name;
    data['roles'] = roles;
    return data;
  }
}
