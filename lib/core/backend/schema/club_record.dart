import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class ClubRecord extends FirestoreRecord {
  ClubRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "nomclub" field.
  String? _nomclub;
  String get nomclub => _nomclub ?? '';
  bool hasNomclub() => _nomclub != null;

  // "niveau" field.
  String? _niveau;
  String get niveau => _niveau ?? '';
  bool hasNiveau() => _niveau != null;

  // "anneecreation" field.
  String? _anneecreation;
  String get anneecreation => _anneecreation ?? '';
  bool hasAnneecreation() => _anneecreation != null;

  // "categorieAge" field.
  String? _categorieAge;
  String get categorieAge => _categorieAge ?? '';
  bool hasCategorieAge() => _categorieAge != null;

  // "typeSport" field.
  String? _typeSport;
  String get typeSport => _typeSport ?? '';
  bool hasTypeSport() => _typeSport != null;

  // "adresseClub" field.
  String? _adresseClub;
  String get adresseClub => _adresseClub ?? '';
  bool hasAdresseClub() => _adresseClub != null;

  // "sitewebClub" field.
  String? _sitewebClub;
  String get sitewebClub => _sitewebClub ?? '';
  bool hasSitewebClub() => _sitewebClub != null;

  // "descriptionClub" field.
  String? _descriptionClub;
  String get descriptionClub => _descriptionClub ?? '';
  bool hasDescriptionClub() => _descriptionClub != null;

  // "documentLegalClub" field.
  String? _documentLegalClub;
  String get documentLegalClub => _documentLegalClub ?? '';
  bool hasDocumentLegalClub() => _documentLegalClub != null;

  // "photo" field.
  String? _photo;
  String get photo => _photo ?? '';
  bool hasPhoto() => _photo != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _nomclub = snapshotData['nomclub'] as String?;
    _niveau = snapshotData['niveau'] as String?;
    _anneecreation = snapshotData['anneecreation'] as String?;
    _categorieAge = snapshotData['categorieAge'] as String?;
    _typeSport = snapshotData['typeSport'] as String?;
    _adresseClub = snapshotData['adresseClub'] as String?;
    _sitewebClub = snapshotData['sitewebClub'] as String?;
    _descriptionClub = snapshotData['descriptionClub'] as String?;
    _documentLegalClub = snapshotData['documentLegalClub'] as String?;
    _photo = snapshotData['photo'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('club')
          : FirebaseFirestore.instance.collectionGroup('club');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('club').doc(id);

  static Stream<ClubRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ClubRecord.fromSnapshot(s));

  static Future<ClubRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ClubRecord.fromSnapshot(s));

  static ClubRecord fromSnapshot(DocumentSnapshot snapshot) => ClubRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ClubRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ClubRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ClubRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ClubRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createClubRecordData({
  String? nomclub,
  String? niveau,
  String? anneecreation,
  String? categorieAge,
  String? typeSport,
  String? adresseClub,
  String? sitewebClub,
  String? descriptionClub,
  String? documentLegalClub,
  String? photo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nomclub': nomclub,
      'niveau': niveau,
      'anneecreation': anneecreation,
      'categorieAge': categorieAge,
      'typeSport': typeSport,
      'adresseClub': adresseClub,
      'sitewebClub': sitewebClub,
      'descriptionClub': descriptionClub,
      'documentLegalClub': documentLegalClub,
      'photo': photo,
    }.withoutNulls,
  );

  return firestoreData;
}

class ClubRecordDocumentEquality implements Equality<ClubRecord> {
  const ClubRecordDocumentEquality();

  @override
  bool equals(ClubRecord? e1, ClubRecord? e2) {
    return e1?.nomclub == e2?.nomclub &&
        e1?.niveau == e2?.niveau &&
        e1?.anneecreation == e2?.anneecreation &&
        e1?.categorieAge == e2?.categorieAge &&
        e1?.typeSport == e2?.typeSport &&
        e1?.adresseClub == e2?.adresseClub &&
        e1?.sitewebClub == e2?.sitewebClub &&
        e1?.descriptionClub == e2?.descriptionClub &&
        e1?.documentLegalClub == e2?.documentLegalClub &&
        e1?.photo == e2?.photo;
  }

  @override
  int hash(ClubRecord? e) => const ListEquality().hash([
        e?.nomclub,
        e?.niveau,
        e?.anneecreation,
        e?.categorieAge,
        e?.typeSport,
        e?.adresseClub,
        e?.sitewebClub,
        e?.descriptionClub,
        e?.documentLegalClub,
        e?.photo
      ]);

  @override
  bool isValidKey(Object? o) => o is ClubRecord;
}
