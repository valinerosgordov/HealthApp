import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../data/user_data.dart';

class UserRepository{
  final CollectionReference _users =
  FirebaseFirestore.instance.collection('users');
  FirebaseStorage storage =
      FirebaseStorage.instance;

  Future setUser({required UserData user}) async {
    await _users.doc(user.uuId).set(user.toMap());
  }


  Future<UserData> getUserById({required String id})async{
    QuerySnapshot snap = await _users.where('id', isEqualTo: id)
        .get();
    UserData result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return UserData.fromMap(map: data);
    }).toList().first;
    return result;
  }

  Future<UserData> getUserByUuid({required String id})async{
    print('UUID REPO IS ${id}');
    QuerySnapshot snap = await _users.where('uuid', isEqualTo: id)
        .get();
    UserData result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return UserData.fromMap(map: data);
    }).toList().first;

    return result;
  }
  Future<UserData?> getUserByUuidIfExist({required String id})async{
    print('UUID REPO IS ${id}');
    QuerySnapshot snap = await _users.where('uuId', isEqualTo: id)
        .get();
    UserData? result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return UserData.fromMap(map: data);
    }).toList().first;

    return result;
  }


  Stream<UserData?> getUserStream({required String user_id}){
    Stream<QuerySnapshot> snapStream = _users.where("uuId",
        isEqualTo: user_id).snapshots(includeMetadataChanges: true);
    Stream<UserData?> userStream =
    snapStream.map((event) => event.docs.isEmpty?null:event.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return UserData.fromMap(map:data);
    }).toList().first);
    return userStream;
  }



   Future<String> savePhoto({required File file}) async {
    String user_uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      String result = '';
      await storage.ref('user_photo/${user_uid}')
              .putFile(file).whenComplete(()async{
               result =  await getPhotoUri(id: user_uid);
               return result;
      });
      return result;


    } on FirebaseException catch (e) {
      print('save photo error');
      return '';
    }
  }
  Future<String> getPhotoUri({required String id})async{
    return  await storage
        .ref('user_photo/$id')
        .getDownloadURL();
  }
}