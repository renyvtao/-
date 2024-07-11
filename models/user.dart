import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String username;
  String email;
  String password;
  String avatarUrl;
  int managementLevel;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.avatarUrl,
    required this.managementLevel,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
