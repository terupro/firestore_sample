import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_sample/model/count.dart';

class CountRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('collection_count');

  void saveCount(Count count) {
    _collection.add(count.toJson());
  }

  Stream<QuerySnapshot> getSnapshot() {
    return _collection
        .orderBy('dateTime', descending: true)
        .limit(5)
        .snapshots();
  }
}
