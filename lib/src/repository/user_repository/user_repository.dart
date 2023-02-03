import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:my_party/src/common_widgets/snackbar/snackbar_information_widget.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(U.User user) async {
    final userDoc = _usersCollection.doc(user.userId);
    await userDoc
        .set(user.toMap())
        .whenComplete(
          () => SnackBarInformationWidget(
            text: AppLocalizations.of(Get.context!)!.createdAccount,
            title: AppLocalizations.of(Get.context!)!.success,
            type: "success",
          ),
        )
        .catchError((error, stackTrace) {
      SnackBarInformationWidget(
        text: AppLocalizations.of(Get.context!)!.somethingWentWrong,
        title: AppLocalizations.of(Get.context!)!.error,
        type: "error",
      );
      print(error.toString());
    });
  }

  Future<void> updateUser(U.User user) async {
    final userDoc = _usersCollection.doc(user.userId);
    await userDoc
        .update(user.toMap())
        .whenComplete(
          () => SnackBarInformationWidget(
            text: AppLocalizations.of(Get.context!)!.updatedAccount,
            title: AppLocalizations.of(Get.context!)!.success,
            type: "success",
          ),
        )
        .catchError((error, stackTrace) {
      () => SnackBarInformationWidget(
            text: AppLocalizations.of(Get.context!)!.somethingWentWrong,
            title: AppLocalizations.of(Get.context!)!.error,
            type: "error",
          );
      print(error.toString());
    });
  }

  Future<void> addFriendRequest(U.User friend, U.User user) async {
    final userDoc = FirebaseFirestore.instance.doc('users/${user.userId}');
    final friendsCollection = userDoc.collection('friendRequests');

    final friendDoc = friendsCollection.doc(friend.userId);
    await friendDoc
        .set(friend.toMap())
        .whenComplete(
          () => SnackBarInformationWidget(
            text: AppLocalizations.of(Get.context!)!.friendRequestSent,
            title: AppLocalizations.of(Get.context!)!.success,
            type: "success",
          ),
        )
        .catchError((error, stackTrace) {
          () => SnackBarInformationWidget(
        text: AppLocalizations.of(Get.context!)!.somethingWentWrong,
        title: AppLocalizations.of(Get.context!)!.error,
        type: "error",
      );
      print(error.toString());
    });
  }

  Future<void> deleteFriendRequest(U.User friend, U.User user) {
    final userDoc = FirebaseFirestore.instance.doc('users/${user.userId}');
    final friendsCollection = userDoc.collection('friendRequests');

    final friendDoc = friendsCollection.doc(friend.userId);
    return friendDoc
        .delete()
        .then((value) => print("Friend request deleted"))
        .catchError(
            (error) => print("Failed to delete friend request: $error"));
  }

  Future<void> addFriend(U.User friend, U.User user) {
    final userDoc = FirebaseFirestore.instance.doc('users/${user.userId}');
    final friendsCollection = userDoc.collection('friends');

    final friendDoc = friendsCollection.doc(friend.userId);
    return friendDoc
        .set(friend.toMap())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addBackFriend(U.User friend, U.User user) async {
    final userDoc = FirebaseFirestore.instance.doc('users/${friend.userId}');
    final friendsCollection = userDoc.collection('friends');

    final friendDoc = friendsCollection.doc(user.userId);
    return friendDoc
        .set(user.toMap())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> deleteFriend(U.User friend, U.User user) {
    final userDoc = FirebaseFirestore.instance.doc('users/${user.userId}');
    final friendsCollection = userDoc.collection('friends');

    final friendDoc = friendsCollection.doc(friend.userId);
    return friendDoc
        .delete()
        .then((value) => print("Friend deleted"))
        .catchError((error) => print("Failed to delete friend : $error"));
  }

  Future<void> deleteFriendBack(U.User friend, U.User user) {
    final userDoc = FirebaseFirestore.instance.doc('users/${friend.userId}');
    final friendsCollection = userDoc.collection('friends');

    final friendDoc = friendsCollection.doc(user.userId);
    return friendDoc
        .delete()
        .then((value) => print("Friend deleted"))
        .catchError((error) => print("Failed to delete friend : $error"));
  }

  Future<U.User?> getUserByUsername(String username) async {
    U.User? user = null;
    QuerySnapshot<Object?> query =
        await _usersCollection.where('userName', isEqualTo: username).get();
    if (query.docs.isNotEmpty) {
      final userJson = query.docs[0].data() as Map<String, dynamic>;
      user = U.User.fromMap(userJson);
    }
    return user;
  }

  Future<List<U.User>> getUsersStartsByUsername(String username) async {
    List<U.User> users = [];
    QuerySnapshot<Object?> query = await _usersCollection.where('userName', isGreaterThanOrEqualTo: username).get();
    if (query.docs.isNotEmpty) {
      for (var user in query.docs) {
        final userJson = user.data() as Map<String, dynamic>;
        users.add(U.User.fromMap(userJson));
      }
    }
    return users;
  }

  Future<List<String>> getFriendsId(String userId) async {
    List<String> friendsId = [];
    final userDoc = FirebaseFirestore.instance.doc('users/$userId');
    final friendsCollection = userDoc.collection('friends');

    QuerySnapshot<Object?> query = await friendsCollection.get();
    if (query.docs.isNotEmpty) {
      for (var friend in query.docs) {
        final friendJson = friend.data() as Map<String, dynamic>;
        friendsId.add(friendJson['userId']);
      }
    }
    return friendsId;
  }

  Future<List<String>> getFriendRequestsId(String userId) async {
    List<String> friendsRequestsId = [];
    final userDoc = FirebaseFirestore.instance.doc('users/$userId');
    final friendsRequestsCollection = userDoc.collection('friendRequests');

    QuerySnapshot<Object?> query = await friendsRequestsCollection.get();
    if (query.docs.isNotEmpty) {
      for (var friend in query.docs) {
        final friendJson = friend.data() as Map<String, dynamic>;
        friendsRequestsId.add(friendJson['userId']);
      }
    }
    return friendsRequestsId;
  }

  Future<U.User?> getUserById(String userId) async {
    try {
      final result = await _usersCollection.doc(userId).get();
      final userJson = result.data() as Map<String, dynamic>;
      return U.User.fromMap(userJson);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> isUserNameAvailable(String username) async {
    try {
      QuerySnapshot<Object?> query =
          await _usersCollection.where('userName', isEqualTo: username).get();
      if (query.docs.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> isMailAvailable(String mail) async {
    try {
      QuerySnapshot<Object?> query =
      await _usersCollection.where('email', isEqualTo: mail).get();
      if (query.docs.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> getProfilPicture(String id) async {
    return await FirebaseStorage.instance
        .ref()
        .child('profile_picture/$id')
        .getDownloadURL();
  }
}
