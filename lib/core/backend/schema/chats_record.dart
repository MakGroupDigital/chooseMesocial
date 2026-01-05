import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';
import '/core/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class ChatsRecord extends FirestoreRecord {
  ChatsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "users" field.
  List<DocumentReference>? _users;
  List<DocumentReference> get users => _users ?? const [];
  bool hasUsers() => _users != null;

  // "createursusers" field.
  DocumentReference? _createursusers;
  DocumentReference? get createursusers => _createursusers;
  bool hasCreateursusers() => _createursusers != null;

  // "textmessage" field.
  String? _textmessage;
  String get textmessage => _textmessage ?? '';
  bool hasTextmessage() => _textmessage != null;

  // "heurcreation" field.
  DateTime? _heurcreation;
  DateTime? get heurcreation => _heurcreation;
  bool hasHeurcreation() => _heurcreation != null;

  // "usernonlu" field.
  DocumentReference? _usernonlu;
  DocumentReference? get usernonlu => _usernonlu;
  bool hasUsernonlu() => _usernonlu != null;

  void _initializeFields() {
    _users = getDataList(snapshotData['users']);
    _createursusers = snapshotData['createursusers'] as DocumentReference?;
    _textmessage = snapshotData['textmessage'] as String?;
    _heurcreation = snapshotData['heurcreation'] as DateTime?;
    _usernonlu = snapshotData['usernonlu'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chats');

  static Stream<ChatsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatsRecord.fromSnapshot(s));

  static Future<ChatsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatsRecord.fromSnapshot(s));

  static ChatsRecord fromSnapshot(DocumentSnapshot snapshot) => ChatsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatsRecordData({
  DocumentReference? createursusers,
  String? textmessage,
  DateTime? heurcreation,
  DocumentReference? usernonlu,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'createursusers': createursusers,
      'textmessage': textmessage,
      'heurcreation': heurcreation,
      'usernonlu': usernonlu,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatsRecordDocumentEquality implements Equality<ChatsRecord> {
  const ChatsRecordDocumentEquality();

  @override
  bool equals(ChatsRecord? e1, ChatsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.users, e2?.users) &&
        e1?.createursusers == e2?.createursusers &&
        e1?.textmessage == e2?.textmessage &&
        e1?.heurcreation == e2?.heurcreation &&
        e1?.usernonlu == e2?.usernonlu;
  }

  @override
  int hash(ChatsRecord? e) => const ListEquality().hash([
        e?.users,
        e?.createursusers,
        e?.textmessage,
        e?.heurcreation,
        e?.usernonlu
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatsRecord;
}
