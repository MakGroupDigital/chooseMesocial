import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class BoxeurRecord extends FirestoreRecord {
  BoxeurRecord._(
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
          ? parent.collection('boxeur')
          : FirebaseFirestore.instance.collectionGroup('boxeur');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('boxeur').doc(id);

  static Stream<BoxeurRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BoxeurRecord.fromSnapshot(s));

  static Future<BoxeurRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BoxeurRecord.fromSnapshot(s));

  static BoxeurRecord fromSnapshot(DocumentSnapshot snapshot) => BoxeurRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BoxeurRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BoxeurRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BoxeurRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BoxeurRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBoxeurRecordData({
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

class BoxeurRecordDocumentEquality implements Equality<BoxeurRecord> {
  const BoxeurRecordDocumentEquality();

  @override
  bool equals(BoxeurRecord? e1, BoxeurRecord? e2) {
    return e1?.nom == e2?.nom && e1?.type == e2?.type;
  }

  @override
  int hash(BoxeurRecord? e) => const ListEquality().hash([e?.nom, e?.type]);

  @override
  bool isValidKey(Object? o) => o is BoxeurRecord;
}
