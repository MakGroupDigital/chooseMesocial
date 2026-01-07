import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class WalletRecord extends FirestoreRecord {
  WalletRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "balance" field.
  double? _balance;
  double get balance => _balance ?? 0.0;
  bool hasBalance() => _balance != null;

  // "points" field.
  int? _points;
  int get points => _points ?? 0;
  bool hasPoints() => _points != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  void _initializeFields() {
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _balance = castToType<double>(snapshotData['balance']);
    _points = castToType<int>(snapshotData['points']);
    _createdAt = snapshotData['created_at'] as DateTime?;
    _updatedAt = snapshotData['updated_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('wallets');

  static Stream<WalletRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => WalletRecord.fromSnapshot(s));

  static Future<WalletRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => WalletRecord.fromSnapshot(s));

  static WalletRecord fromSnapshot(DocumentSnapshot snapshot) => WalletRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static WalletRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      WalletRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'WalletRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is WalletRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createWalletRecordData({
  DocumentReference? userRef,
  double? balance,
  int? points,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_ref': userRef,
      'balance': balance,
      'points': points,
      'created_at': createdAt,
      'updated_at': updatedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class WalletRecordDocumentEquality implements Equality<WalletRecord> {
  const WalletRecordDocumentEquality();

  @override
  bool equals(WalletRecord? e1, WalletRecord? e2) {
    return e1?.userRef == e2?.userRef &&
        e1?.balance == e2?.balance &&
        e1?.points == e2?.points &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt;
  }

  @override
  int hash(WalletRecord? e) => const ListEquality().hash([
        e?.userRef,
        e?.balance,
        e?.points,
        e?.createdAt,
        e?.updatedAt
      ]);

  @override
  bool isValidKey(Object? o) => o is WalletRecord;
}