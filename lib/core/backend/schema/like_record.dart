import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class LikeRecord extends FirestoreRecord {
  LikeRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "like" field.
  String? _like;
  String get like => _like ?? '';
  bool hasLike() => _like != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _like = snapshotData['like'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('like')
          : FirebaseFirestore.instance.collectionGroup('like');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('like').doc(id);

  static Stream<LikeRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LikeRecord.fromSnapshot(s));

  static Future<LikeRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LikeRecord.fromSnapshot(s));

  static LikeRecord fromSnapshot(DocumentSnapshot snapshot) => LikeRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LikeRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LikeRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LikeRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LikeRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLikeRecordData({
  String? like,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'like': like,
    }.withoutNulls,
  );

  return firestoreData;
}

class LikeRecordDocumentEquality implements Equality<LikeRecord> {
  const LikeRecordDocumentEquality();

  @override
  bool equals(LikeRecord? e1, LikeRecord? e2) {
    return e1?.like == e2?.like;
  }

  @override
  int hash(LikeRecord? e) => const ListEquality().hash([e?.like]);

  @override
  bool isValidKey(Object? o) => o is LikeRecord;
}
