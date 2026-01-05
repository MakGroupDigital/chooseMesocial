import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class PresseRecord extends FirestoreRecord {
  PresseRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "Nomjournaliste" field.
  String? _nomjournaliste;
  String get nomjournaliste => _nomjournaliste ?? '';
  bool hasNomjournaliste() => _nomjournaliste != null;

  // "NomJournalChaine" field.
  String? _nomJournalChaine;
  String get nomJournalChaine => _nomJournalChaine ?? '';
  bool hasNomJournalChaine() => _nomJournalChaine != null;

  // "Poste" field.
  String? _poste;
  String get poste => _poste ?? '';
  bool hasPoste() => _poste != null;

  // "NumeroCarte" field.
  String? _numeroCarte;
  String get numeroCarte => _numeroCarte ?? '';
  bool hasNumeroCarte() => _numeroCarte != null;

  // "SportCouverts" field.
  String? _sportCouverts;
  String get sportCouverts => _sportCouverts ?? '';
  bool hasSportCouverts() => _sportCouverts != null;

  // "biographie" field.
  String? _biographie;
  String get biographie => _biographie ?? '';
  bool hasBiographie() => _biographie != null;

  // "liensociaux" field.
  String? _liensociaux;
  String get liensociaux => _liensociaux ?? '';
  bool hasLiensociaux() => _liensociaux != null;

  // "acreditation" field.
  String? _acreditation;
  String get acreditation => _acreditation ?? '';
  bool hasAcreditation() => _acreditation != null;

  // "facebook" field.
  String? _facebook;
  String get facebook => _facebook ?? '';
  bool hasFacebook() => _facebook != null;

  // "X" field.
  String? _x;
  String get x => _x ?? '';
  bool hasX() => _x != null;

  // "photo" field.
  String? _photo;
  String get photo => _photo ?? '';
  bool hasPhoto() => _photo != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _nomjournaliste = snapshotData['Nomjournaliste'] as String?;
    _nomJournalChaine = snapshotData['NomJournalChaine'] as String?;
    _poste = snapshotData['Poste'] as String?;
    _numeroCarte = snapshotData['NumeroCarte'] as String?;
    _sportCouverts = snapshotData['SportCouverts'] as String?;
    _biographie = snapshotData['biographie'] as String?;
    _liensociaux = snapshotData['liensociaux'] as String?;
    _acreditation = snapshotData['acreditation'] as String?;
    _facebook = snapshotData['facebook'] as String?;
    _x = snapshotData['X'] as String?;
    _photo = snapshotData['photo'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('presse')
          : FirebaseFirestore.instance.collectionGroup('presse');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('presse').doc(id);

  static Stream<PresseRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PresseRecord.fromSnapshot(s));

  static Future<PresseRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PresseRecord.fromSnapshot(s));

  static PresseRecord fromSnapshot(DocumentSnapshot snapshot) => PresseRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PresseRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PresseRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PresseRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PresseRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPresseRecordData({
  String? nomjournaliste,
  String? nomJournalChaine,
  String? poste,
  String? numeroCarte,
  String? sportCouverts,
  String? biographie,
  String? liensociaux,
  String? acreditation,
  String? facebook,
  String? x,
  String? photo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Nomjournaliste': nomjournaliste,
      'NomJournalChaine': nomJournalChaine,
      'Poste': poste,
      'NumeroCarte': numeroCarte,
      'SportCouverts': sportCouverts,
      'biographie': biographie,
      'liensociaux': liensociaux,
      'acreditation': acreditation,
      'facebook': facebook,
      'X': x,
      'photo': photo,
    }.withoutNulls,
  );

  return firestoreData;
}

class PresseRecordDocumentEquality implements Equality<PresseRecord> {
  const PresseRecordDocumentEquality();

  @override
  bool equals(PresseRecord? e1, PresseRecord? e2) {
    return e1?.nomjournaliste == e2?.nomjournaliste &&
        e1?.nomJournalChaine == e2?.nomJournalChaine &&
        e1?.poste == e2?.poste &&
        e1?.numeroCarte == e2?.numeroCarte &&
        e1?.sportCouverts == e2?.sportCouverts &&
        e1?.biographie == e2?.biographie &&
        e1?.liensociaux == e2?.liensociaux &&
        e1?.acreditation == e2?.acreditation &&
        e1?.facebook == e2?.facebook &&
        e1?.x == e2?.x &&
        e1?.photo == e2?.photo;
  }

  @override
  int hash(PresseRecord? e) => const ListEquality().hash([
        e?.nomjournaliste,
        e?.nomJournalChaine,
        e?.poste,
        e?.numeroCarte,
        e?.sportCouverts,
        e?.biographie,
        e?.liensociaux,
        e?.acreditation,
        e?.facebook,
        e?.x,
        e?.photo
      ]);

  @override
  bool isValidKey(Object? o) => o is PresseRecord;
}
