import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class PronosticRecord extends FirestoreRecord {
  PronosticRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "match_ref" field.
  DocumentReference? _matchRef;
  DocumentReference? get matchRef => _matchRef;
  bool hasMatchRef() => _matchRef != null;

  // "prediction" field.
  String? _prediction;
  String get prediction => _prediction ?? '';
  bool hasPrediction() => _prediction != null;

  // "submitted_at" field.
  DateTime? _submittedAt;
  DateTime? get submittedAt => _submittedAt;
  bool hasSubmittedAt() => _submittedAt != null;

  // "status" field.
  String? _status;
  String get status => _status ?? 'pending';
  bool hasStatus() => _status != null;

  // "user_name" field.
  String? _userName;
  String get userName => _userName ?? '';
  bool hasUserName() => _userName != null;

  void _initializeFields() {
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _matchRef = snapshotData['match_ref'] as DocumentReference?;
    _prediction = snapshotData['prediction'] as String?;
    _submittedAt = snapshotData['submitted_at'] as DateTime?;
    _status = snapshotData['status'] as String?;
    _userName = snapshotData['user_name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('pronostics');

  static Stream<PronosticRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PronosticRecord.fromSnapshot(s));

  static Future<PronosticRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PronosticRecord.fromSnapshot(s));

  static PronosticRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PronosticRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PronosticRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PronosticRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PronosticRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PronosticRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPronosticRecordData({
  DocumentReference? userRef,
  DocumentReference? matchRef,
  String? prediction,
  DateTime? submittedAt,
  String? status,
  String? userName,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_ref': userRef,
      'match_ref': matchRef,
      'prediction': prediction,
      'submitted_at': submittedAt,
      'status': status,
      'user_name': userName,
    }.withoutNulls,
  );

  return firestoreData;
}

class PronosticRecordDocumentEquality implements Equality<PronosticRecord> {
  const PronosticRecordDocumentEquality();

  @override
  bool equals(PronosticRecord? e1, PronosticRecord? e2) {
    return e1?.userRef == e2?.userRef &&
        e1?.matchRef == e2?.matchRef &&
        e1?.prediction == e2?.prediction &&
        e1?.submittedAt == e2?.submittedAt &&
        e1?.status == e2?.status &&
        e1?.userName == e2?.userName;
  }

  @override
  int hash(PronosticRecord? e) => const ListEquality().hash([
        e?.userRef,
        e?.matchRef,
        e?.prediction,
        e?.submittedAt,
        e?.status,
        e?.userName
      ]);

  @override
  bool isValidKey(Object? o) => o is PronosticRecord;
}