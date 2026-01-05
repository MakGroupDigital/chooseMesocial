import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class AthleteRecord extends FirestoreRecord {
  AthleteRecord._(
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
          ? parent.collection('athlete')
          : FirebaseFirestore.instance.collectionGroup('athlete');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('athlete').doc(id);

  static Stream<AthleteRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AthleteRecord.fromSnapshot(s));

  static Future<AthleteRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AthleteRecord.fromSnapshot(s));

  static AthleteRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AthleteRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AthleteRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AthleteRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AthleteRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AthleteRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAthleteRecordData({
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

class AthleteRecordDocumentEquality implements Equality<AthleteRecord> {
  const AthleteRecordDocumentEquality();

  @override
  bool equals(AthleteRecord? e1, AthleteRecord? e2) {
    return e1?.nom == e2?.nom && e1?.type == e2?.type;
  }

  @override
  int hash(AthleteRecord? e) => const ListEquality().hash([e?.nom, e?.type]);

  @override
  bool isValidKey(Object? o) => o is AthleteRecord;
}
