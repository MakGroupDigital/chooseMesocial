import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class TransactionRecord extends FirestoreRecord {
  TransactionRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "wallet_ref" field.
  DocumentReference? _walletRef;
  DocumentReference? get walletRef => _walletRef;
  bool hasWalletRef() => _walletRef != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  bool hasAmount() => _amount != null;

  // "reward_type" field.
  String? _rewardType;
  String get rewardType => _rewardType ?? '';
  bool hasRewardType() => _rewardType != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "match_ref" field.
  DocumentReference? _matchRef;
  DocumentReference? get matchRef => _matchRef;
  bool hasMatchRef() => _matchRef != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _walletRef = snapshotData['wallet_ref'] as DocumentReference?;
    _type = snapshotData['type'] as String?;
    _amount = castToType<double>(snapshotData['amount']);
    _rewardType = snapshotData['reward_type'] as String?;
    _description = snapshotData['description'] as String?;
    _matchRef = snapshotData['match_ref'] as DocumentReference?;
    _createdAt = snapshotData['created_at'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('transactions')
          : FirebaseFirestore.instance.collectionGroup('transactions');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('transactions').doc(id);

  static Stream<TransactionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TransactionRecord.fromSnapshot(s));

  static Future<TransactionRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TransactionRecord.fromSnapshot(s));

  static TransactionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TransactionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TransactionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TransactionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TransactionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TransactionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTransactionRecordData({
  DocumentReference? walletRef,
  String? type,
  double? amount,
  String? rewardType,
  String? description,
  DocumentReference? matchRef,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'wallet_ref': walletRef,
      'type': type,
      'amount': amount,
      'reward_type': rewardType,
      'description': description,
      'match_ref': matchRef,
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class TransactionRecordDocumentEquality implements Equality<TransactionRecord> {
  const TransactionRecordDocumentEquality();

  @override
  bool equals(TransactionRecord? e1, TransactionRecord? e2) {
    return e1?.walletRef == e2?.walletRef &&
        e1?.type == e2?.type &&
        e1?.amount == e2?.amount &&
        e1?.rewardType == e2?.rewardType &&
        e1?.description == e2?.description &&
        e1?.matchRef == e2?.matchRef &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(TransactionRecord? e) => const ListEquality().hash([
        e?.walletRef,
        e?.type,
        e?.amount,
        e?.rewardType,
        e?.description,
        e?.matchRef,
        e?.createdAt
      ]);

  @override
  bool isValidKey(Object? o) => o is TransactionRecord;
}