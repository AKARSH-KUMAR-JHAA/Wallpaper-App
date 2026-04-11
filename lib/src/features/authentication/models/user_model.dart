import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;
  final String? profilePicture;

  const UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.password,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "PhoneNo": phoneNo,
      "Password": password,
      "ProfilePicture": profilePicture,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return UserModel(
      id: document.id,
      email: data["Email"] ?? "",
      password: data["Password"] ?? "",
      fullName: data["FullName"] ?? "",
      phoneNo: data["PhoneNo"] ?? "",
      profilePicture: data["ProfilePicture"],
    );
  }
}