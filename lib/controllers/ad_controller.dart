import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:health_app/ui/screens/auth/code_screen.dart';
import '../domain/data/ad_data.dart';
import '../domain/repositories/ad_repository.dart';
import '../domain/repositories/auth_repository.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../domain/data/ad_data.dart';

class AdController extends GetxController {
  final AdRepository _adRepository = AdRepository();
  Rxn<List<AdData>> partnersList = Rxn();
  Rxn<List<AdData>> partnersListSecond = Rxn();
  List<DocumentSnapshot> documentList = <DocumentSnapshot>[];
  List<DocumentSnapshot> documentSecondList = <DocumentSnapshot>[];
  Rxn<AdData> selectPartner = Rxn();
  RxBool showLoader = false.obs;

  void searchPartners({required String query}) async {
    partnersList.value?.clear();
    partnersList.value = await _adRepository.searchAd(query: query);
    partnersList.refresh();
  }

  void initSelectPartner(String eventId) {
    _adRepository.eventStreamById(eventId).listen((event) {
      selectPartner.value = event;
    });
  }

  Future<List<AdData>> updateSecondPartnersList() async {
    documentSecondList = await _adRepository.getSecondAd();
    List<AdData> commentsData = documentSecondList.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return AdData.fromMap(map: data);
    }).toList();
    partnersListSecond.value = commentsData;
    return commentsData;
  }

  void getSecondNextPage() async {
    showLoader.value = true;
    documentSecondList.addAll(
        await _adRepository.getSecondAdNextPage(docs: documentSecondList));
    List<AdData> videos = documentSecondList.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return AdData.fromMap(map: data);
    }).toList();
    videos.sort((a, b) => a.createAt.compareTo(b.createAt));
    showLoader.value = false;
    partnersListSecond.value = videos.reversed.toList();
  }

  Future<List<AdData>> updatePartnersList() async {
    documentList = await _adRepository.getAd();
    List<AdData> commentsData = documentList.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return AdData.fromMap(map: data);
    }).toList();
    partnersList.value = commentsData;

    return commentsData;
  }

  void getNextPage() async {
    showLoader.value = true;
    documentList.addAll(await _adRepository.getAdNextPage(docs: documentList));
    List<AdData> videos = documentList.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return AdData.fromMap(map: data);
    }).toList();
    videos.sort((a, b) => a.createAt.compareTo(b.createAt));
    showLoader.value = false;
    partnersList.value = videos.reversed.toList();
  }
}
