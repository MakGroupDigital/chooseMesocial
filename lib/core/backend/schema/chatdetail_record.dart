import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class ChatdetailRecord extends FirestoreRecord {
  ChatdetailRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "messageref" field.
  DocumentReference? _messageref;
  DocumentReference? get messageref => _messageref;
  bool hasMessageref() => _messageref != null;

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  bool hasMessage() => _message != null;

  // "dateheur" field.
  DateTime? _dateheur;
  DateTime? get dateheur => _dateheur;
  bool hasDateheur() => _dateheur != null;

  // "createur" field.
  DocumentReference? _createur;
  DocumentReference? get createur => _createur;
  bool hasCreateur() => _createur != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _messageref = snapshotData['messageref'] as DocumentReference?;
    _message = snapshotData['message'] as String?;
    _dateheur = snapshotData['dateheur'] as DateTime?;
    _createur = snapshotData['createur'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('chatdetail')
          : FirebaseFirestore.instance.collectionGroup('chatdetail');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('chatdetail').doc(id);

  static Stream<ChatdetailRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatdetailRecord.fromSnapshot(s));

  static Future<ChatdetailRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatdetailRecord.fromSnapshot(s));

  static ChatdetailRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ChatdetailRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatdetailRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatdetailRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatdetailRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatdetailRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatdetailRecordData({
  DocumentReference? messageref,
  String? message,
  DateTime? dateheur,
  DocumentReference? createur,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'messageref': messageref,
      'message': message,
      'dateheur': dateheur,
      'createur': createur,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatdetailRecordDocumentEquality implements Equality<ChatdetailRecord> {
  const ChatdetailRecordDocumentEquality();

  @override
  bool equals(ChatdetailRecord? e1, ChatdetailRecord? e2) {
    return e1?.messageref == e2?.messageref &&
        e1?.message == e2?.message &&
        e1?.dateheur == e2?.dateheur &&
        e1?.createur == e2?.createur;
  }

  @override
  int hash(ChatdetailRecord? e) => const ListEquality()
      .hash([e?.messageref, e?.message, e?.dateheur, e?.createur]);

  @override
  bool isValidKey(Object? o) => o is ChatdetailRecord;
}
