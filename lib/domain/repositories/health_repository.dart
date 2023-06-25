import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import '../data/health_data.dart';


class HealthRepository {
  final CollectionReference _ads =
  FirebaseFirestore.instance.collection('health');
  FirebaseStorage storage =
      FirebaseStorage.instance;

  Future<List<HealthData>> searchPartners({required String query})async {
    QuerySnapshot snap = await _ads
        .where("name" , isLessThanOrEqualTo: "$query\uf8ff")
        .where("name", isGreaterThanOrEqualTo: query)
        .get();
    List<HealthData> result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return HealthData.fromMap(map: data);
    }).toList();
    return result;
  }
  removePartner({required HealthData data})async{
    await _ads.doc(data.id).delete();
  }


  Stream<HealthData> eventStreamById(String eventId){
    Stream<QuerySnapshot> snapStream =
    _ads
        .where('id',
        isEqualTo:eventId)
        .snapshots(includeMetadataChanges: true);
    return
      snapStream.map((event) =>
      event.docs.reversed.map((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        return HealthData.fromMap( map: data);
      }).toList().first);
  }

  Future setPartner({required HealthData partnerData}) async {
    await _ads.doc(partnerData.id).set(partnerData.toMap());
  }


  Future<HealthData> getPartnerById({required String id})async{
    QuerySnapshot snap = await _ads.where('id', isEqualTo: id)
        .get();
    HealthData result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return HealthData.fromMap(map: data);
    }).toList().first;
    return result;
  }


  Future<HealthData?> getPartnerByUuidIfExist({required String id})async{
    QuerySnapshot snap = await _ads.where('uuId', isEqualTo: id)
        .get();
    HealthData? result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return HealthData.fromMap(map: data);
    }).toList().first;

    return result;
  }


  Stream<HealthData?> getPartnerStream({required String user_id}){
    Stream<QuerySnapshot> snapStream = _ads.where("uuId",
        isEqualTo: user_id).snapshots(includeMetadataChanges: true);
    Stream<HealthData?> userStream =
    snapStream.map((event) => event.docs.isEmpty?null:event.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return HealthData.fromMap(map:data);
    }).toList().first);
    return userStream;
  }

  Future<List<DocumentSnapshot>> getPartners()async{
    QuerySnapshot snap = await _ads
        .orderBy('createAt', descending: true)
        .get();
    List<DocumentSnapshot> result =  snap.docs;
    return result;
  }
  Future<List<DocumentSnapshot>> getCommentNextPage({required List<DocumentSnapshot> docs})async{
    QuerySnapshot snap = await _ads.orderBy('createAt', descending: true)
        .startAfterDocument(docs[docs.length - 1])
        .limit(5)
        .get();
    List<DocumentSnapshot> result = [];
    result = snap.docs;
    return result;
  }



  Future<String> savePhoto({
    required Uint8List file,
    required String partner_id,
    String? prefix,
  }) async {
    // String user_uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      String result = '';
      await storage
          .ref('health_photo/${partner_id}${prefix ?? ""}')
          .putData(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        result = await getPhotoUri(id: partner_id + (prefix ?? ""));
        return result;
      });
      return result;
    } on FirebaseException catch (e) {
      print('save photo error ${e}');
      return '';
    }
  }
  Future<String> getPhotoUri({required String id})async{
    return  await storage
        .ref('health_photo/$id')
        .getDownloadURL();
  }


  Future<String> saveVideo({required Uint8List file, required String partner_id}) async {
    print('save video');
    // String user_uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      String result = '';
      await storage.ref('health_video/${partner_id}')
          .putData(file, SettableMetadata(contentType: 'video/mp4'),).whenComplete(()async{
        result =  await getVideoUri(id: partner_id);
        return result;
      });
      return result;


    } on FirebaseException catch (e) {
      print('save video error');
      return '';
    }
  }
  Future<String> getVideoUri({required String id})async{
    return  await storage
        .ref('health_video/$id')
        .getDownloadURL();
  }

  Future<HealthData?> getItemByBarCode(String code) async {
    QuerySnapshot snap = await _ads.where("barcode", isEqualTo: code).get();

    List<HealthData> data = snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return HealthData.fromMap(map: data);
    }).toList();
    if (data.isNotEmpty) {

      return data.first;
    }
    return null;
  }
}