import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import '../data/ad_data.dart';

class AdRepository {
  final CollectionReference _ads = FirebaseFirestore.instance.collection('ads');
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<AdData>> searchAd({required String query}) async {
    QuerySnapshot snap = await _ads
        .where("name", isLessThanOrEqualTo: "$query\uf8ff")
        .where("name", isGreaterThanOrEqualTo: query)
        .get();
    List<AdData> result = snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return AdData.fromMap(map: data);
    }).toList();
    return result;
  }

  removeAd({required AdData data}) async {
    await _ads.doc(data.id).delete();
  }

  Stream<AdData> eventStreamById(String eventId) {
    Stream<QuerySnapshot> snapStream = _ads
        .where('id', isEqualTo: eventId)
        .snapshots(includeMetadataChanges: true);
    return snapStream.map((event) => event.docs.reversed
        .map((e) {
          Map<String, dynamic> data = e.data() as Map<String, dynamic>;
          return AdData.fromMap(map: data);
        })
        .toList()
        .first);
  }

  Future<AdData> getAdById({required String id}) async {
    QuerySnapshot snap = await _ads.where('id', isEqualTo: id).get();
    AdData result = snap.docs
        .map((e) {
          Map<String, dynamic> data = e.data() as Map<String, dynamic>;
          return AdData.fromMap(map: data);
        })
        .toList()
        .first;
    return result;
  }

  Future<AdData?> getAdByUuidIfExist({required String id}) async {
    QuerySnapshot snap = await _ads.where('uuId', isEqualTo: id).get();
    AdData? result = snap.docs
        .map((e) {
          Map<String, dynamic> data = e.data() as Map<String, dynamic>;
          return AdData.fromMap(map: data);
        })
        .toList()
        .first;

    return result;
  }

  Stream<AdData?> getAdStream({required String user_id}) {
    Stream<QuerySnapshot> snapStream = _ads
        .where("uuId", isEqualTo: user_id)
        .snapshots(includeMetadataChanges: true);
    Stream<AdData?> userStream = snapStream.map((event) => event.docs.isEmpty
        ? null
        : event.docs
            .map((e) {
              Map<String, dynamic> data = e.data() as Map<String, dynamic>;
              return AdData.fromMap(map: data);
            })
            .toList()
            .first);
    return userStream;
  }

  Future<List<DocumentSnapshot>> getAd() async {
    QuerySnapshot snap =
        await _ads.orderBy('createAt', descending: true).limit(5).get();
    List<DocumentSnapshot> result = snap.docs;
    return result;
  }

  Future<List<DocumentSnapshot>> getSecondAd() async {
    QuerySnapshot snap =
        await _ads.orderBy('createAt', descending: false).limit(5).get();
    List<DocumentSnapshot> result = snap.docs;
    return result;
  }

  Future<List<DocumentSnapshot>> getSecondAdNextPage(
      {required List<DocumentSnapshot> docs}) async {
    QuerySnapshot snap = await _ads
        .orderBy('createAt')
        .startAfterDocument(docs[docs.length - 1])
        .limit(5)
        .get();
    List<DocumentSnapshot> result = [];
    result = snap.docs;
    return result;
  }

  Future<List<DocumentSnapshot>> getAdNextPage(
      {required List<DocumentSnapshot> docs}) async {
    QuerySnapshot snap = await _ads
        .orderBy('createAt', descending: true)
        .startAfterDocument(docs[docs.length - 1])
        .limit(5)
        .get();
    List<DocumentSnapshot> result = [];
    result = snap.docs;
    return result;
  }

  Future<String> savePhoto(
      {required Uint8List file, required String partner_id}) async {
    // String user_uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      String result = '';
      await storage
          .ref('ad_photo/${partner_id}')
          .putData(
            file,
            SettableMetadata(contentType: 'image/jpeg'),
          )
          .whenComplete(() async {
        result = await getPhotoUri(id: partner_id);
        return result;
      });
      return result;
    } on FirebaseException catch (e) {
      print('save photo error');
      return '';
    }
  }

  Future<String> getPhotoUri({required String id}) async {
    return await storage.ref('ad_photo/$id').getDownloadURL();
  }

  Future<String> saveVideo(
      {required Uint8List file, required String partner_id}) async {
    print('save video');
    // String user_uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      String result = '';
      await storage
          .ref('ad_video/${partner_id}')
          .putData(
            file,
            SettableMetadata(contentType: 'video/mp4'),
          )
          .whenComplete(() async {
        result = await getVideoUri(id: partner_id);
        return result;
      });
      return result;
    } on FirebaseException catch (e) {
      print('save video error');
      return '';
    }
  }

  Future<String> getVideoUri({required String id}) async {
    return await storage.ref('ad_video/$id').getDownloadURL();
  }
}
