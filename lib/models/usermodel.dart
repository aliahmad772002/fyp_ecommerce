// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? uid;
  String? userImage;
  String? userName;
  String? userEmail;
  String? userPasword;
  String? userToken;
  UserModel({
    this.uid,
    this.userImage,
    this.userName,
    this.userEmail,
    this.userPasword,
    this.userToken,
  });

  UserModel copyWith({
    String? uid,
    String? userImage,
    String? userName,
    String? userEmail,
    String? userPasword,
    String? userToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPasword: userPasword ?? this.userPasword,
      userToken: userToken ?? this.userToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userImage': userImage,
      'userName': userName,
      'userEmail': userEmail,
      'userPasword': userPasword,
      'userToken': userToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      userImage: map['userImage'] != null ? map['userImage'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userEmail: map['userEmail'] != null ? map['userEmail'] as String : null,
      userPasword: map['userPasword'] != null ? map['userPasword'] as String : null,
      userToken: map['userToken'] != null ? map['userToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, userImage: $userImage, userName: $userName, userEmail: $userEmail, userPasword: $userPasword, userToken: $userToken)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return
      other.uid == uid &&
          other.userImage == userImage &&
          other.userName == userName &&
          other.userEmail == userEmail &&
          other.userPasword == userPasword &&
          other.userToken == userToken;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
    userImage.hashCode ^
    userName.hashCode ^
    userEmail.hashCode ^
    userPasword.hashCode ^
    userToken.hashCode;
  }
}
