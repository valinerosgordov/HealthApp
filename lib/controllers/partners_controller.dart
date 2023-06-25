import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/user_controller.dart';
import 'package:health_app/domain/data/become_data.dart';
import 'package:health_app/servises/location.dart';
import 'dart:io';

import '../domain/data/partner_data.dart';
import '../domain/repositories/partners_repository.dart';
import 'package:geolocator/geolocator.dart';

class PartnersController extends GetxController {
  final PartnersRepository _partnersRepository = PartnersRepository();
  Rxn<List<PartnerData>> partnersList = Rxn();
  List<DocumentSnapshot> documentList = <DocumentSnapshot>[];
  RxList<String> selectCategories = RxList<String>([]);
  RxList<Shop> geoList = RxList([]);
  Rxn<PartnerData> selectPartner = Rxn();
  RxBool showLoader = false.obs;
  String queryValue = '';
  RxBool onMap = false.obs;
  Rxn<Position> userPosition = Rxn();
  final UserController _userController = Get.find();

  List<BecomeData>? becomeData;

  searchPartners({
    required String query,
  }) async {
    partnersList.value?.clear();
    partnersList.value = await _partnersRepository.searchPartners(
        query: queryValue,
        categories:
            selectCategories.value.isNotEmpty ? selectCategories.value : null);
    partnersList.refresh();
  }

  removePartner({required PartnerData data}) async {
    await _partnersRepository.removePartner(data: data);
  }

  addShop({required PartnerData partnerData, required Shop shopData}) async {
    List<Shop> newShops = partnerData.shops;
    if (newShops
        .where((element) =>
            element.lat == shopData.lat && element.lon == shopData.lon)
        .isEmpty) {
      newShops.add(shopData);
      print("SHOP DATA IS ${shopData.lat} ${shopData.lon}");
      PartnerData newData = partnerData.copyWith(shops: newShops);
      print(newData.toMap()['shops']);
      await setData(data: newData);
    }
  }

  removeShop({required PartnerData partnerData, required Shop shopData}) async {
    List<Shop> newShops = <Shop>[];
    for (Shop i in partnerData.shops) {
      if (i.lon != shopData.lon && i.lat != shopData.lat) {
        newShops.add(i);
      }
    }
    await setData(data: partnerData.copyWith(shops: newShops));
  }

  addTag({required PartnerData partnerData, required String tag}) async {
    List<String> newShops = partnerData.tags;
    if (newShops.where((element) => element == tag).isEmpty) {
      newShops.add(tag);
      PartnerData newData = partnerData.copyWith(tags: newShops);
      await setData(data: newData);
    }
  }

  removeTag({required PartnerData partnerData, required String tag}) async {
    List<String> newShops = <String>[];
    for (String i in partnerData.tags) {
      if (i != tag) {
        newShops.add(i);
      }
    }
    await setData(data: partnerData.copyWith(tags: newShops));
  }

  getUserPosition() async {
    userPosition.value = await LocationService.determinePosition();
  }

  Future<bool> setBecomePartner(Map<String, String> map) async {
    final CollectionReference _become =
        FirebaseFirestore.instance.collection('become');

    map["uid"] = _userController.user.value!.uuId;

    await _become.add(map);

    return true;
  }

  Future<List<BecomeData>> getBecomePartner() async {
    final CollectionReference _become =
        FirebaseFirestore.instance.collection('become');

    QuerySnapshot snap = await _become.get();
    List<BecomeData> result = snap.docs.map((e) {
      return BecomeData.fromMap(map: (e.data() as Map<String, dynamic>));
    }).toList().where((e) => e.uid == _userController.user.value!.uuId).toList();
    return result;
  }

  initSelectPartner(String eventId) {
    _partnersRepository.eventStreamById(eventId).listen((event) {
      selectPartner.value = event;
    });
  }

  getMapList() async {
    partnersList.value = await _partnersRepository.getMapPartners();
  }

  setDataWithPhoto({required PartnerData data, required Uint8List file}) async {
    showLoader.value = true;
    String result =
        await _partnersRepository.savePhoto(file: file, partner_id: data.id);
    setData(data: data.copyWith(photo: result));
  }

  setData({required PartnerData data}) async {
    await _partnersRepository.setPartner(partnerData: data);
    showLoader.value = false;
  }

  Future<List<PartnerData>> updatePartnersList() async {
    documentList = await _partnersRepository.getPartners();
    List<PartnerData> commentsData = documentList.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return PartnerData.fromMap(map: data);
    }).toList();
    partnersList.value = commentsData;

    return commentsData;
  }

  getNextPage() async {
    print('getNextPage');
    showLoader.value = true;
    List<DocumentSnapshot> s =
        await _partnersRepository.getCommentNextPage(docs: documentList);
    if (s.isNotEmpty) {
      documentList.addAll(s);
      List<PartnerData> videos = documentList.map((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        return PartnerData.fromMap(map: data);
      }).toList();
      videos.sort((a, b) => a.createAt.compareTo(b.createAt));
      showLoader.value = false;
      partnersList.value = videos.reversed.toList();
    } else {
      showLoader.value = false;
    }
  }
}
