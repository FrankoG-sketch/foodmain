class UserMod {
  String uid;
  String email;
  String firstName;
  String lastName;
  var address;

  UserMod({this.uid, this.email, this.firstName, this.lastName, this.address});

  // receiving data from server
  factory UserMod.fromMap(map) {
    return UserMod(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
    };
  }
}
