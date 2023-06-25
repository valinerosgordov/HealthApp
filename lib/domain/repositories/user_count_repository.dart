import 'package:cloud_firestore/cloud_firestore.dart';

class UserCountRepository{
  final CollectionReference _partners =
  FirebaseFirestore.instance.collection('user_count');

  Stream<int> userCountStreamById(){
    Stream<QuerySnapshot> snapStream =
    _partners
        .snapshots(includeMetadataChanges: true);
    return
      snapStream.map((event) =>
      event.docs.reversed.map((e) {
        int data = (e.data() as Map<String, dynamic>)['count'];
        return data;
      }).toList().first);
  }

  Future<int> getCount()async{
    QuerySnapshot snap = await _partners.get();
    int result = (snap.docs.first.data() as Map<String, dynamic>)['count'];
    return result;
  }

  setData({required int count})async{
    await _partners.doc('09TFvuzuEMQkZT2ONBMA').set(<String, dynamic>{'count': count});
  }


}