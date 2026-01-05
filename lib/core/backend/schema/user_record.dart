import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class UserRecord extends FirestoreRecord {
  UserRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "statut" field.
  String? _statut;
  String get statut => _statut ?? '';
  bool hasStatut() => _statut != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "discipline" field.
  String? _discipline;
  String get discipline => _discipline ?? '';
  bool hasDiscipline() => _discipline != null;

  // "pays" field.
  String? _pays;
  String get pays => _pays ?? '';
  bool hasPays() => _pays != null;

  // "atype" field.
  bool? _atype;
  bool get atype => _atype ?? false;
  bool hasAtype() => _atype != null;

  // "type2" field.
  String? _type2;
  String get type2 => _type2 ?? '';
  bool hasType2() => _type2 != null;

  // "type3" field.
  String? _type3;
  String get type3 => _type3 ?? '';
  bool hasType3() => _type3 != null;

  // "type4" field.
  String? _type4;
  String get type4 => _type4 ?? '';
  bool hasType4() => _type4 != null;

  // "codepays" field.
  String? _codepays;
  String get codepays => _codepays ?? '';
  bool hasCodepays() => _codepays != null;

  // "etat" field.
  String? _etat;
  String get etat => _etat ?? '';
  bool hasEtat() => _etat != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _statut = snapshotData['statut'] as String?;
    _type = snapshotData['type'] as String?;
    _discipline = snapshotData['discipline'] as String?;
    _pays = snapshotData['pays'] as String?;
    _atype = snapshotData['atype'] as bool?;
    _type2 = snapshotData['type2'] as String?;
    _type3 = snapshotData['type3'] as String?;
    _type4 = snapshotData['type4'] as String?;
    _codepays = snapshotData['codepays'] as String?;
    _etat = snapshotData['etat'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('user');

  static Stream<UserRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserRecord.fromSnapshot(s));

  static Future<UserRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserRecord.fromSnapshot(s));

  static UserRecord fromSnapshot(DocumentSnapshot snapshot) => UserRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? statut,
  String? type,
  String? discipline,
  String? pays,
  bool? atype,
  String? type2,
  String? type3,
  String? type4,
  String? codepays,
  String? etat,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'statut': statut,
      'type': type,
      'discipline': discipline,
      'pays': pays,
      'atype': atype,
      'type2': type2,
      'type3': type3,
      'type4': type4,
      'codepays': codepays,
      'etat': etat,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserRecordDocumentEquality implements Equality<UserRecord> {
  const UserRecordDocumentEquality();

  @override
  bool equals(UserRecord? e1, UserRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.statut == e2?.statut &&
        e1?.type == e2?.type &&
        e1?.discipline == e2?.discipline &&
        e1?.pays == e2?.pays &&
        e1?.atype == e2?.atype &&
        e1?.type2 == e2?.type2 &&
        e1?.type3 == e2?.type3 &&
        e1?.type4 == e2?.type4 &&
        e1?.codepays == e2?.codepays &&
        e1?.etat == e2?.etat;
  }

  @override
  int hash(UserRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.statut,
        e?.type,
        e?.discipline,
        e?.pays,
        e?.atype,
        e?.type2,
        e?.type3,
        e?.type4,
        e?.codepays,
        e?.etat
      ]);

  @override
  bool isValidKey(Object? o) => o is UserRecord;
}
