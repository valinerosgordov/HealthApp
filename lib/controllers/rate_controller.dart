import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateController extends GetxController {
  final RateRepository _repository = RateRepository();
  final LettersRepository _letterRepository = LettersRepository();
  Rxn<List<VoteData>> voteList = Rxn(<VoteData>[]);
  Rxn<List<LetterData>> lettersList = Rxn(<LetterData>[]);
  Rxn<bool> isDisable = Rxn();
  Rxn<bool> isVisible = Rxn();

  void getPartnerRate(String id, String uid) {
    _repository.getRates().listen((value) {
      voteList.value = value.where((vote) => vote.id == id).toList();
      isDisable.value = voteList.value?.where((vote) => vote.uid == uid).toList().isNotEmpty;
    });
  }

  Future<void> setPartnerRate(String id, String uid, double vote) async {
    await _repository.add(id, uid, vote);
  }

  Future<void> setLetterPartner(Map<String, dynamic> map) async {
    await _letterRepository.addLetter(map);
  }

  void getPartnerLetters(String id, String uid) {
    _letterRepository.getList().listen((event) {
      lettersList.value = event.where((vote) => vote.id == id).toList();
      isVisible.value = lettersList.value?.where((vote) => vote.uid == uid).toList().isNotEmpty;
    });
  }
}

class RateRepository {
  final CollectionReference _rates =
  FirebaseFirestore.instance.collection('rates');

  Stream<List<VoteData>> getRates() {
    Stream<QuerySnapshot> snapStream = _rates.snapshots(includeMetadataChanges: true);
    return snapStream.map((event) => event.docs.reversed
        .map((e) => VoteData.fromMap(map: e.data() as Map<String, dynamic>))
        .toList());
  }

  add(String id, String uid, double vote) async {
    await _rates.add({
      "id":id,
      "uid":uid,
      "rate":vote,
    });
  }
}

class LettersRepository {
  final CollectionReference _letters =
  FirebaseFirestore.instance.collection('letters');

  Stream<List<LetterData>> getList() {
    Stream<QuerySnapshot> snapStream =
    _letters.snapshots(includeMetadataChanges: true);
    return snapStream.map((event) => event.docs.reversed
        .map((e) => LetterData.fromMap(map: e.data() as Map<String, dynamic>))
        .toList());
  }

  addLetter(Map<String, dynamic> map) {
    _letters.add(map);
  }
}

class LetterData {
  const LetterData({
    required this.id,
    required this.uid,
    required this.text,
    required this.isVisible,
  });

  final String id;
  final String uid;
  final String text;
  final bool isVisible;

  factory LetterData.fromMap({required Map<String, dynamic> map}) {
    return LetterData(
      id: map['id'],
      uid: map['uid'],
      text: map['text'],
      isVisible: map['isVisible'] ?? false,
    );
  }
}

class VoteData {
  const VoteData({
    required this.id,
    required this.uid,
    required this.rate,
  });

  final String id;
  final String uid;
  final int rate;

  factory VoteData.fromMap({required Map<String, dynamic> map}) {
    return VoteData(
      id: map['id'],
      uid: map['uid'],
      rate: map['rate'].round(),
    );
  }
}
