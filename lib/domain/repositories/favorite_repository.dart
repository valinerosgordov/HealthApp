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

class FavoriteRepository{
  final CollectionReference _partners =
  FirebaseFirestore.instance.collection('partners');

  Future<List<PartnerData>?> getPartnerListStream({required List<String> likes})async{
    QuerySnapshot snap = await _partners.where("id",
        whereIn: likes).get();
    List<PartnerData> result =  snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return PartnerData.fromMap(map: data);
    }).toList();
    return result;
  }


}