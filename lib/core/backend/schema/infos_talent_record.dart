import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';
import '/core/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class InfosTalentRecord extends FirestoreRecord {
  InfosTalentRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "nomComplet" field.
  String? _nomComplet;
  String get nomComplet => _nomComplet ?? '';
  bool hasNomComplet() => _nomComplet != null;

  // "DateDeNaissance" field.
  String? _dateDeNaissance;
  String get dateDeNaissance => _dateDeNaissance ?? '';
  bool hasDateDeNaissance() => _dateDeNaissance != null;

  // "nationalite" field.
  String? _nationalite;
  String get nationalite => _nationalite ?? '';
  bool hasNationalite() => _nationalite != null;

  // "discipline" field.
  String? _discipline;
  String get discipline => _discipline ?? '';
  bool hasDiscipline() => _discipline != null;

  // "poste" field.
  String? _poste;
  String get poste => _poste ?? '';
  bool hasPoste() => _poste != null;

  // "taille" field.
  String? _taille;
  String get taille => _taille ?? '';
  bool hasTaille() => _taille != null;

  // "poids" field.
  String? _poids;
  String get poids => _poids ?? '';
  bool hasPoids() => _poids != null;

  // "club" field.
  String? _club;
  String get club => _club ?? '';
  bool hasClub() => _club != null;

  // "anneeExperience" field.
  String? _anneeExperience;
  String get anneeExperience => _anneeExperience ?? '';
  bool hasAnneeExperience() => _anneeExperience != null;

  // "palmares" field.
  String? _palmares;
  String get palmares => _palmares ?? '';
  bool hasPalmares() => _palmares != null;

  // "numeroPhone" field.
  String? _numeroPhone;
  String get numeroPhone => _numeroPhone ?? '';
  bool hasNumeroPhone() => _numeroPhone != null;

  // "ville" field.
  String? _ville;
  String get ville => _ville ?? '';
  bool hasVille() => _ville != null;

  // "anneeexp" field.
  String? _anneeexp;
  String get anneeexp => _anneeexp ?? '';
  bool hasAnneeexp() => _anneeexp != null;

  // "photo" field.
  String? _photo;
  String get photo => _photo ?? '';
  bool hasPhoto() => _photo != null;

  // "lienWhatsapp" field.
  String? _lienWhatsapp;
  String get lienWhatsapp => _lienWhatsapp ?? '';
  bool hasLienWhatsapp() => _lienWhatsapp != null;

  // "pays" field.
  String? _pays;
  String get pays => _pays ?? '';
  bool hasPays() => _pays != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "like" field.
  List<DocumentReference>? _like;
  List<DocumentReference> get like => _like ?? const [];
  bool hasLike() => _like != null;

  // "refPub" field.
  List<DocumentReference>? _refPub;
  List<DocumentReference> get refPub => _refPub ?? const [];
  bool hasRefPub() => _refPub != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _nomComplet = snapshotData['nomComplet'] as String?;
    _dateDeNaissance = snapshotData['DateDeNaissance'] as String?;
    _nationalite = snapshotData['nationalite'] as String?;
    _discipline = snapshotData['discipline'] as String?;
    _poste = snapshotData['poste'] as String?;
    _taille = snapshotData['taille'] as String?;
    _poids = snapshotData['poids'] as String?;
    _club = snapshotData['club'] as String?;
    _anneeExperience = snapshotData['anneeExperience'] as String?;
    _palmares = snapshotData['palmares'] as String?;
    _numeroPhone = snapshotData['numeroPhone'] as String?;
    _ville = snapshotData['ville'] as String?;
    _anneeexp = snapshotData['anneeexp'] as String?;
    _photo = snapshotData['photo'] as String?;
    _lienWhatsapp = snapshotData['lienWhatsapp'] as String?;
    _pays = snapshotData['pays'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _like = getDataList(snapshotData['like']);
    _refPub = getDataList(snapshotData['refPub']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('infosTalent')
          : FirebaseFirestore.instance.collectionGroup('infosTalent');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('infosTalent').doc(id);

  static Stream<InfosTalentRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => InfosTalentRecord.fromSnapshot(s));

  static Future<InfosTalentRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => InfosTalentRecord.fromSnapshot(s));

  static InfosTalentRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InfosTalentRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static InfosTalentRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      InfosTalentRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'InfosTalentRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is InfosTalentRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createInfosTalentRecordData({
  String? nomComplet,
  String? dateDeNaissance,
  String? nationalite,
  String? discipline,
  String? poste,
  String? taille,
  String? poids,
  String? club,
  String? anneeExperience,
  String? palmares,
  String? numeroPhone,
  String? ville,
  String? anneeexp,
  String? photo,
  String? lienWhatsapp,
  String? pays,
  DateTime? date,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nomComplet': nomComplet,
      'DateDeNaissance': dateDeNaissance,
      'nationalite': nationalite,
      'discipline': discipline,
      'poste': poste,
      'taille': taille,
      'poids': poids,
      'club': club,
      'anneeExperience': anneeExperience,
      'palmares': palmares,
      'numeroPhone': numeroPhone,
      'ville': ville,
      'anneeexp': anneeexp,
      'photo': photo,
      'lienWhatsapp': lienWhatsapp,
      'pays': pays,
      'date': date,
    }.withoutNulls,
  );

  return firestoreData;
}

class InfosTalentRecordDocumentEquality implements Equality<InfosTalentRecord> {
  const InfosTalentRecordDocumentEquality();

  @override
  bool equals(InfosTalentRecord? e1, InfosTalentRecord? e2) {
    const listEquality = ListEquality();
    return e1?.nomComplet == e2?.nomComplet &&
        e1?.dateDeNaissance == e2?.dateDeNaissance &&
        e1?.nationalite == e2?.nationalite &&
        e1?.discipline == e2?.discipline &&
        e1?.poste == e2?.poste &&
        e1?.taille == e2?.taille &&
        e1?.poids == e2?.poids &&
        e1?.club == e2?.club &&
        e1?.anneeExperience == e2?.anneeExperience &&
        e1?.palmares == e2?.palmares &&
        e1?.numeroPhone == e2?.numeroPhone &&
        e1?.ville == e2?.ville &&
        e1?.anneeexp == e2?.anneeexp &&
        e1?.photo == e2?.photo &&
        e1?.lienWhatsapp == e2?.lienWhatsapp &&
        e1?.pays == e2?.pays &&
        e1?.date == e2?.date &&
        listEquality.equals(e1?.like, e2?.like) &&
        listEquality.equals(e1?.refPub, e2?.refPub);
  }

  @override
  int hash(InfosTalentRecord? e) => const ListEquality().hash([
        e?.nomComplet,
        e?.dateDeNaissance,
        e?.nationalite,
        e?.discipline,
        e?.poste,
        e?.taille,
        e?.poids,
        e?.club,
        e?.anneeExperience,
        e?.palmares,
        e?.numeroPhone,
        e?.ville,
        e?.anneeexp,
        e?.photo,
        e?.lienWhatsapp,
        e?.pays,
        e?.date,
        e?.like,
        e?.refPub
      ]);

  @override
  bool isValidKey(Object? o) => o is InfosTalentRecord;
}
