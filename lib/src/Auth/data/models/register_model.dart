class RegisterModel {
  String? status;
  String? message;
  String? token;
  User? user;

  RegisterModel({
    this.status,
    this.message,
    this.token,
    this.user,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      status: json['status'],
      message: json['message'],
      token: json['token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      if (user != null) 'user': user!.toJson(),
    };
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? phone;

  User({
    this.id,
    this.username,
    this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
    };
  }
}
