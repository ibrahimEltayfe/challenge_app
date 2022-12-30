class UserModel{
  final String? name;
  final String? uid;
  final String? email;

  UserModel({
   this.name,
   this.uid,
   this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid':uid,
    };
  }

  factory UserModel.fromMap(Map<String,dynamic> data) {
    return UserModel(
      name : data['name'] ?? '',
      uid : data['uid'] ?? '',
      email : data['email'] ?? '',
    );
  }

}