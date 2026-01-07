import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class WithdrawalRecord extends FirestoreRecord {
  WithdrawalRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "wallet_ref" field.
  DocumentReference? _walletRef;
  DocumentReference? get walletRef => _walletRef;
  bool hasWalletRef() => _walletRef != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  bool hasAmount() => _amount != null;

  // "method" field.
  String? _method;
  String get method => _method ?? '';
  bool hasMethod() => _method != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "status" field.
  String? _status;
  String get status => _status ?? 'pending';
  bool hasStatus() => _status != null;

  // "rejection_reason" field.
  String? _rejectionReason;
  String get rejectionReason => _rejectionReason ?? '';
  bool hasRejectionReason() => _rejectionReason != null;

  // "requested_at" field.
  DateTime? _requestedAt;
  DateTime? get requestedAt => _requestedAt;
  bool hasRequestedAt() => _requestedAt != null;

  // "processed_at" field.
  DateTime? _processedAt;
  DateTime? get processedAt => _processedAt;
  bool hasProcessedAt() => _processedAt != null;

  void _initializeFields() {
    _walletRef = snapshotData['wallet_ref'] as DocumentReference?;
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _amount = castToType<double>(snapshotData['amount']);
    _method = snapshotData['method'] as String?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _status = snapshotData['status'] as String?;
    _rejectionReason = snapshotData['rejection_reason'] as String?;
    _requestedAt = snapshotData['requested_at'] as DateTime?;
    _processedAt = snapshotData['processed_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('withdrawals');

  static Stream<WithdrawalRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => WithdrawalRecord.fromSnapshot(s));

  static Future<WithdrawalRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => WithdrawalRecord.fromSnapshot(s));

  static WithdrawalRecord fromSnapshot(DocumentSnapshot snapshot) =>
      WithdrawalRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static WithdrawalRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      WithdrawalRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'WithdrawalRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is WithdrawalRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createWithdrawalRecordData({
  DocumentReference? walletRef,
  DocumentReference? userRef,
  double? amount,
  String? method,
  String? phoneNumber,
  String? status,
  String? rejectionReason,
  DateTime? requestedAt,
  DateTime? processedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'wallet_ref': walletRef,
      'user_ref': userRef,
      'amount': amount,
      'method': method,
      'phone_number': phoneNumber,
      'status': status,
      'rejection_reason': rejectionReason,
      'requested_at': requestedAt,
      'processed_at': processedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class WithdrawalRecordDocumentEquality implements Equality<WithdrawalRecord> {
  const WithdrawalRecordDocumentEquality();

  @override
  bool equals(WithdrawalRecord? e1, WithdrawalRecord? e2) {
    return e1?.walletRef == e2?.walletRef &&
        e1?.userRef == e2?.userRef &&
        e1?.amount == e2?.amount &&
        e1?.method == e2?.method &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.status == e2?.status &&
        e1?.rejectionReason == e2?.rejectionReason &&
        e1?.requestedAt == e2?.requestedAt &&
        e1?.processedAt == e2?.processedAt;
  }

  @override
  int hash(WithdrawalRecord? e) => const ListEquality().hash([
        e?.walletRef,
        e?.userRef,
        e?.amount,
        e?.method,
        e?.phoneNumber,
        e?.status,
        e?.rejectionReason,
        e?.requestedAt,
        e?.processedAt
      ]);

  @override
  bool isValidKey(Object? o) => o is WithdrawalRecord;
}