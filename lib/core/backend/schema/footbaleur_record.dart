import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class FootbaleurRecord extends FirestoreRecord {
  FootbaleurRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "nom" field.
  DocumentReference? _nom;
  DocumentReference? get nom => _nom;
  bool hasNom() => _nom != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _nom = snapshotData['nom'] as DocumentReference?;
    _type = snapshotData['type'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('footbaleur')
          : FirebaseFirestore.instance.collectionGroup('footbaleur');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('footbaleur').doc(id);

  static Stream<FootbaleurRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FootbaleurRecord.fromSnapshot(s));

  static Future<FootbaleurRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FootbaleurRecord.fromSnapshot(s));

  static FootbaleurRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FootbaleurRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FootbaleurRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FootbaleurRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FootbaleurRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FootbaleurRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFootbaleurRecordData({
  DocumentReference? nom,
  String? type,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nom': nom,
      'type': type,
    }.withoutNulls,
  );

  return firestoreData;
}

class FootbaleurRecordDocumentEquality implements Equality<FootbaleurRecord> {
  const FootbaleurRecordDocumentEquality();

  @override
  bool equals(FootbaleurRecord? e1, FootbaleurRecord? e2) {
    return e1?.nom == e2?.nom && e1?.type == e2?.type;
  }

  @override
  int hash(FootbaleurRecord? e) => const ListEquality().hash([e?.nom, e?.type]);

  @override
  bool isValidKey(Object? o) => o is FootbaleurRecord;
}
