import 'dart:typed_data';

import '../domain/data/health_data.dart';
import '../domain/repositories/health_repository.dart';
import 'package:get/get.dart';
import 'package:health_app/domain/data/city_data.dart';

import '../domain/repositories/city_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HealthController extends GetxController {
  final HealthRepository _healthRepository = HealthRepository();
  Rxn<List<HealthData>> partnersList = Rxn();
  List<DocumentSnapshot> documentList = <DocumentSnapshot>[];
  Rxn<HealthData> selectPartner = Rxn();
  RxBool showLoader = false.obs;

  initSelectPartner(String eventId) {
    _healthRepository.eventStreamById(eventId).listen((event) {
      selectPartner.value = event;
    });
  }

  setDataWithPhoto({
    required HealthData data,
    required Uint8List? file,
    required bool isVideo,
    required Uint8List? preview,
  }) async {
    showLoader.value = true;
    HealthData _cache = data;

    if (file != null && file.isNotEmpty) {
      String _resultFile = isVideo
          ? await _healthRepository.saveVideo(file: file, partner_id: data.id)
          : await _healthRepository.savePhoto(file: file, partner_id: data.id);
      _cache = _cache.copyWith(photo: _resultFile);
    }

    if (preview != null && preview.isNotEmpty) {
      String _resultPreview = await _healthRepository.savePhoto(
          file: preview, partner_id: data.id, prefix: "_preview");
      _cache = _cache.copyWith(preview: _resultPreview);
    }

    _cache = _cache.copyWith(status: false);

    setData(data: _cache);
  }

  setData({required HealthData data}) async {
    await _healthRepository.setPartner(partnerData: data);
    showLoader.value = false;
  }

  Future<List<HealthData>> updatePartnersList() async {
    documentList = await _healthRepository.getPartners();
    List<HealthData> commentsData = documentList.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return HealthData.fromMap(map: data);
    }).toList();
    partnersList.value = commentsData;

    return commentsData;
  }

  void getNextPage() async {
    showLoader.value = true;
    documentList
        .addAll(await _healthRepository.getCommentNextPage(docs: documentList));
    List<HealthData> videos = documentList.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return HealthData.fromMap(map: data);
    }).toList();
    videos.sort((a, b) => a.createAt.compareTo(b.createAt));
    showLoader.value = false;
    partnersList.value = videos.reversed.toList();
  }

  Future<HealthData?> getItemByBarCode(String code) async {
    return await _healthRepository.getItemByBarCode(code);
  }
}
