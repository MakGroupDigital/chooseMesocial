import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';
import '/core/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class ListeutilisateurRecord extends FirestoreRecord {
  ListeutilisateurRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "nom" field.
  DocumentReference? _nom;
  DocumentReference? get nom => _nom;
  bool hasNom() => _nom != null;

  // "nomtalent" field.
  List<DocumentReference>? _nomtalent;
  List<DocumentReference> get nomtalent => _nomtalent ?? const [];
  bool hasNomtalent() => _nomtalent != null;

  void _initializeFields() {
    _nom = snapshotData['nom'] as DocumentReference?;
    _nomtalent = getDataList(snapshotData['nomtalent']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('listeutilisateur');

  static Stream<ListeutilisateurRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ListeutilisateurRecord.fromSnapshot(s));

  static Future<ListeutilisateurRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ListeutilisateurRecord.fromSnapshot(s));

  static ListeutilisateurRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ListeutilisateurRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ListeutilisateurRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ListeutilisateurRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ListeutilisateurRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ListeutilisateurRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createListeutilisateurRecordData({
  DocumentReference? nom,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nom': nom,
    }.withoutNulls,
  );

  return firestoreData;
}

class ListeutilisateurRecordDocumentEquality
    implements Equality<ListeutilisateurRecord> {
  const ListeutilisateurRecordDocumentEquality();

  @override
  bool equals(ListeutilisateurRecord? e1, ListeutilisateurRecord? e2) {
    const listEquality = ListEquality();
    return e1?.nom == e2?.nom &&
        listEquality.equals(e1?.nomtalent, e2?.nomtalent);
  }

  @override
  int hash(ListeutilisateurRecord? e) =>
      const ListEquality().hash([e?.nom, e?.nomtalent]);

  @override
  bool isValidKey(Object? o) => o is ListeutilisateurRecord;
}
