import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class RecruteurRecord extends FirestoreRecord {
  RecruteurRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "NomOrganisation" field.
  String? _nomOrganisation;
  String get nomOrganisation => _nomOrganisation ?? '';
  bool hasNomOrganisation() => _nomOrganisation != null;

  // "typeOrganisation" field.
  String? _typeOrganisation;
  String get typeOrganisation => _typeOrganisation ?? '';
  bool hasTypeOrganisation() => _typeOrganisation != null;

  // "Poste" field.
  String? _poste;
  String get poste => _poste ?? '';
  bool hasPoste() => _poste != null;

  // "anneeOrganisation" field.
  String? _anneeOrganisation;
  String get anneeOrganisation => _anneeOrganisation ?? '';
  bool hasAnneeOrganisation() => _anneeOrganisation != null;

  // "sportInteretOrganisation" field.
  String? _sportInteretOrganisation;
  String get sportInteretOrganisation => _sportInteretOrganisation ?? '';
  bool hasSportInteretOrganisation() => _sportInteretOrganisation != null;

  // "sitewebOrganisation" field.
  String? _sitewebOrganisation;
  String get sitewebOrganisation => _sitewebOrganisation ?? '';
  bool hasSitewebOrganisation() => _sitewebOrganisation != null;

  // "descriptionOrganisation" field.
  String? _descriptionOrganisation;
  String get descriptionOrganisation => _descriptionOrganisation ?? '';
  bool hasDescriptionOrganisation() => _descriptionOrganisation != null;

  // "accreditationOrganisation" field.
  String? _accreditationOrganisation;
  String get accreditationOrganisation => _accreditationOrganisation ?? '';
  bool hasAccreditationOrganisation() => _accreditationOrganisation != null;

  // "photo" field.
  String? _photo;
  String get photo => _photo ?? '';
  bool hasPhoto() => _photo != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _nomOrganisation = snapshotData['NomOrganisation'] as String?;
    _typeOrganisation = snapshotData['typeOrganisation'] as String?;
    _poste = snapshotData['Poste'] as String?;
    _anneeOrganisation = snapshotData['anneeOrganisation'] as String?;
    _sportInteretOrganisation =
        snapshotData['sportInteretOrganisation'] as String?;
    _sitewebOrganisation = snapshotData['sitewebOrganisation'] as String?;
    _descriptionOrganisation =
        snapshotData['descriptionOrganisation'] as String?;
    _accreditationOrganisation =
        snapshotData['accreditationOrganisation'] as String?;
    _photo = snapshotData['photo'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('recruteur')
          : FirebaseFirestore.instance.collectionGroup('recruteur');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('recruteur').doc(id);

  static Stream<RecruteurRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RecruteurRecord.fromSnapshot(s));

  static Future<RecruteurRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RecruteurRecord.fromSnapshot(s));

  static RecruteurRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RecruteurRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RecruteurRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RecruteurRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RecruteurRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RecruteurRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRecruteurRecordData({
  String? nomOrganisation,
  String? typeOrganisation,
  String? poste,
  String? anneeOrganisation,
  String? sportInteretOrganisation,
  String? sitewebOrganisation,
  String? descriptionOrganisation,
  String? accreditationOrganisation,
  String? photo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'NomOrganisation': nomOrganisation,
      'typeOrganisation': typeOrganisation,
      'Poste': poste,
      'anneeOrganisation': anneeOrganisation,
      'sportInteretOrganisation': sportInteretOrganisation,
      'sitewebOrganisation': sitewebOrganisation,
      'descriptionOrganisation': descriptionOrganisation,
      'accreditationOrganisation': accreditationOrganisation,
      'photo': photo,
    }.withoutNulls,
  );

  return firestoreData;
}

class RecruteurRecordDocumentEquality implements Equality<RecruteurRecord> {
  const RecruteurRecordDocumentEquality();

  @override
  bool equals(RecruteurRecord? e1, RecruteurRecord? e2) {
    return e1?.nomOrganisation == e2?.nomOrganisation &&
        e1?.typeOrganisation == e2?.typeOrganisation &&
        e1?.poste == e2?.poste &&
        e1?.anneeOrganisation == e2?.anneeOrganisation &&
        e1?.sportInteretOrganisation == e2?.sportInteretOrganisation &&
        e1?.sitewebOrganisation == e2?.sitewebOrganisation &&
        e1?.descriptionOrganisation == e2?.descriptionOrganisation &&
        e1?.accreditationOrganisation == e2?.accreditationOrganisation &&
        e1?.photo == e2?.photo;
  }

  @override
  int hash(RecruteurRecord? e) => const ListEquality().hash([
        e?.nomOrganisation,
        e?.typeOrganisation,
        e?.poste,
        e?.anneeOrganisation,
        e?.sportInteretOrganisation,
        e?.sitewebOrganisation,
        e?.descriptionOrganisation,
        e?.accreditationOrganisation,
        e?.photo
      ]);

  @override
  bool isValidKey(Object? o) => o is RecruteurRecord;
}
