import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import '../data/partner_data.dart';



class PartnersRepository{
  final CollectionReference _partners =
  FirebaseFirestore.instance.collection('partners');
  FirebaseStorage storage =
      FirebaseStorage.instance;

  Future<List<PartnerData>> searchPartners({required String query,
  required List<String>? categories})async {
    if(query.isNotEmpty){
    QuerySnapshot snap = await _partners
        .where("name" , isLessThanOrEqualTo: "${query.toLowerCase()}\uf8ff")
        .where("name", isGreaterThanOrEqualTo: "${query.toUpperCase()}")
      //  .where("name" , isLessThanOrEqualTo: "${query.toUpperCase()}\uf8ff")
    //.where('name', isGreaterThanOrEqualTo: query.toUpperCase())
   .where('categories', arrayContainsAny: categories).get();
    QuerySnapshot snap2 = await _partners.where('tags', arrayContainsAny: [query]).get();
    List<PartnerData> result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return PartnerData.fromMap(map: data);
    }).toList();
    result.addAll(snap2.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return PartnerData.fromMap(map: data);
    }).toList());
    return result;
  }else{
      QuerySnapshot snap = await _partners
         // .where("name" , isLessThanOrEqualTo: "$query\uf8ff")
          //.where("name", isGreaterThanOrEqualTo: query)
          .where('categories', arrayContainsAny: categories)
          .get();
      List<PartnerData> result =  snap.docs.map((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        return PartnerData.fromMap(map: data);
      }).toList();
      return result;
    }
  }
  removePartner({required PartnerData data})async{
    await _partners.doc(data.id).delete();
  }


  Stream<PartnerData> eventStreamById(String eventId){
    Stream<QuerySnapshot> snapStream =
    _partners
        .where('id',
        isEqualTo:eventId)
        .snapshots(includeMetadataChanges: true);
    return
      snapStream.map((event) =>
      event.docs.reversed.map((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        return PartnerData.fromMap( map: data);
      }).toList().first);
  }

  Future setPartner({required PartnerData partnerData}) async {
    await _partners.doc(partnerData.id).set(partnerData.toMap());
  }


  Future<PartnerData> getPartnerById({required String id})async{
    QuerySnapshot snap = await _partners.where('id', isEqualTo: id)
        .get();
    PartnerData result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return PartnerData.fromMap(map: data);
    }).toList().first;
    return result;
  }


  Future<PartnerData?> getPartnerByUuidIfExist({required String id})async{
    QuerySnapshot snap = await _partners.where('uuId', isEqualTo: id)
        .get();
    PartnerData? result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return PartnerData.fromMap(map: data);
    }).toList().first;

    return result;
  }


  Stream<PartnerData?> getPartnerStream({required String user_id}){
    Stream<QuerySnapshot> snapStream = _partners.where("uuId",
        isEqualTo: user_id).snapshots(includeMetadataChanges: true);
    Stream<PartnerData?> userStream =
    snapStream.map((event) => event.docs.isEmpty?null:event.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return PartnerData.fromMap(map:data);
    }).toList().first);
    return userStream;
  }

  Future<List<DocumentSnapshot>> getPartners()async{
    QuerySnapshot snap = await _partners
        .orderBy('createAt', descending: true).limit(10)
        .get();
    List<DocumentSnapshot> result =  snap.docs;
    return result;
  }

  Future<List<PartnerData>> getMapPartners()async{
    QuerySnapshot snap = await _partners
        .get();
    List<PartnerData> result =
    snap.docs.map((e) {return PartnerData.fromMap(map: (e.data() as Map<String, dynamic>));}).toList();
    return result;
  }

  Future<List<DocumentSnapshot>> getCommentNextPage({required List<DocumentSnapshot> docs})async{
    try{
      QuerySnapshot snap = await _partners.orderBy('createAt', descending: true)
          .startAfterDocument(docs[docs.length - 1])
          .limit(10)
          .get();
      List<DocumentSnapshot> result = [];
      result = snap.docs;
      return result;
    }catch (e){
      return [];
    }
  }



  Future<String> savePhoto({required Uint8List file, required String partner_id}) async {
   // String user_uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      String result = '';
      await storage.ref('partners_photo/${partner_id}')
          .putData(file, SettableMetadata(contentType: 'image/jpeg'),).whenComplete(()async{
        result =  await getPhotoUri(id: partner_id);
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
        .ref('partners_photo/$id')
        .getDownloadURL();
  }
}