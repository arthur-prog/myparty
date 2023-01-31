import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final usersCollection = FirebaseFirestore.instance.collection('users');

class User {
  late String userId;
  late String userName;
  late String email;
  late String firstName;
  late String lastName;
  late String birthDate;

  User({
    required this.userId,
    required this.userName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthDate
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        userId: map['userId'],
        userName: map['userName'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        birthDate: map['birthDate']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
    };
  }

  Future<void> addUser(){
    final userDoc = usersCollection.doc(userId);
    return userDoc.set(toMap())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addFriendRequest(User user) async{
    final userDoc = FirebaseFirestore.instance.doc('users/$userId');
    final friendsCollection = userDoc.collection('friendRequests');

    final friendDoc = friendsCollection.doc(user.userId);
    return friendDoc.set(user.toMap())
        .then((value) => print("Friend Request Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> deleteFriendRequest(User friend){
    final userDoc = FirebaseFirestore.instance.doc('users/$userId');
    final friendsCollection = userDoc.collection('friendRequests');

    final friendDoc = friendsCollection.doc(friend.userId);
    return friendDoc.delete()
        .then((value) => print("Friend request deleted"))
        .catchError((error) => print("Failed to delete friend request: $error"));
  }

  Future<void> addFriend(User friend) {
    final userDoc = FirebaseFirestore.instance.doc('users/$userId');
    final friendsCollection = userDoc.collection('friends');

    final friendDoc = friendsCollection.doc(friend.userId);
    return friendDoc.set(friend.toMap())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addBackFriend(User friend) async{
    final userDoc = FirebaseFirestore.instance.doc('users/${friend.userId}');
    final friendsCollection = userDoc.collection('friends');

    final friendDoc = friendsCollection.doc(userId);
    return friendDoc.set(toMap())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> deleteFriend(User friend){
    final userDoc = FirebaseFirestore.instance.doc('users/$userId');
    final friendsCollection = userDoc.collection('friends');

    final friendDoc = friendsCollection.doc(friend.userId);
    return friendDoc.delete()
        .then((value) => print("Friend deleted"))
        .catchError((error) => print("Failed to delete friend : $error"));
  }

  Future<void> deleteFriendBack(User friend){
    final userDoc = FirebaseFirestore.instance.doc('users/${friend.userId}');
    final friendsCollection = userDoc.collection('friends');

    final friendDoc = friendsCollection.doc(userId);
    return friendDoc.delete()
        .then((value) => print("Friend deleted"))
        .catchError((error) => print("Failed to delete friend : $error"));
  }


  static Future<User?> getUserByUsername(String username) async {
    User? user = null;
    QuerySnapshot<Object?> query = await usersCollection.where('userName', isEqualTo: username).get();
    if(query.docs.isNotEmpty){
      final userJson = query.docs[0].data() as Map<String, dynamic>;
      user = User.fromMap(userJson);
    }
    return user;
  }

  static Future<User?> getUserById(String userId) async {
    final result = await usersCollection.doc(userId).get();
    final userJson = result.data() as Map<String, dynamic>;
    return User.fromMap(userJson);
  }

  static Future<bool> isUserNameAvailable(String username) async{
    QuerySnapshot<Object?> query = await usersCollection.where('userName', isEqualTo: username).get();
    if(query.docs.isNotEmpty){
      return false;
    } else {
      return true;
    }
  }

  static Future<String> getProfilPicture(String id) async {
    return await FirebaseStorage.instance
        .ref()
        .child('profile_picture/$id')
        .getDownloadURL();
  }
}
