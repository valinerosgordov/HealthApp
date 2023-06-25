import 'package:cloud_firestore/cloud_firestore.dart';

class BecomeRepository{
  final CollectionReference _become =
  FirebaseFirestore.instance.collection('become_visible');

  Stream<int> userCountStreamById(){
    Stream<QuerySnapshot> snapStream =
    _become
        .snapshots(includeMetadataChanges: true);
    return
      snapStream.map((event) =>
      event.docs.reversed.map((e) {
        bool data = (e.data() as Map<String, dynamic>)['is_visible'] as bool;
        return data ? 1 : 0;
      }).toList().first);
  }
}