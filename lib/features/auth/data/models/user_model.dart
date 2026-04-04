import 'package:attendalert/features/auth/domain/entities/user.dart';

class UserModel {
  final int id;
  final String name;
  final String email;

  //positional constructor u need to knw the sequence
  //named constructor that is not the case
  const UserModel({required this.id, required this.name, required this.email});
  //factory constructor object create nahi karta directly
  // Wo sirf return karta hai kisi aur constructor ka result
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }

  User toEntity() {
    return User(id: id, name: name, email: email);
  }
}
