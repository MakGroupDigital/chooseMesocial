import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class BasketeurRecord extends FirestoreRecord {
  BasketeurRecord._(
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
          ? parent.collection('basketeur')
          : FirebaseFirestore.instance.collectionGroup('basketeur');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('basketeur').doc(id);

  static Stream<BasketeurRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BasketeurRecord.fromSnapshot(s));

  static Future<BasketeurRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BasketeurRecord.fromSnapshot(s));

  static BasketeurRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BasketeurRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BasketeurRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BasketeurRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BasketeurRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BasketeurRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBasketeurRecordData({
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

class BasketeurRecordDocumentEquality implements Equality<BasketeurRecord> {
  const BasketeurRecordDocumentEquality();

  @override
  bool equals(BasketeurRecord? e1, BasketeurRecord? e2) {
    return e1?.nom == e2?.nom && e1?.type == e2?.type;
  }

  @override
  int hash(BasketeurRecord? e) => const ListEquality().hash([e?.nom, e?.type]);

  @override
  bool isValidKey(Object? o) => o is BasketeurRecord;
}
