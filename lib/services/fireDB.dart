import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phone_login/models/todo.dart';
import 'package:phone_login/models/user.dart';

class FireDb {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
        "photoURL": user.photoURL
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteNewUser(String uid) async {
    try {
      await _firestore.collection("users").doc(uid).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();

      return UserModel.fromSnapShot(_doc);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodo(String content, String uid) async {
    try {
      await _firestore.collection("users").doc(uid).collection("todos").add({
        'dateCreated': Timestamp.now(),
        'content': content,
        'done': false,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<TodoModel>> todoStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("todos")
        .orderBy("dateCreated", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<TodoModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(TodoModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Future<void> updateTodo(TodoModel todo, String uid) async {
    try {
      _firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .doc(todo.todoId)
          .update(todo.toJson());
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteTodo(TodoModel todo, String uid) async {
    try {
      _firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .doc(todo.todoId)
          .delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateURL(String uid, String downloadUrl) async {
    try {
      _firestore.collection("users").doc(uid).update({'photoURL': downloadUrl});
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
