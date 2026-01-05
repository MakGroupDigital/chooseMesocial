import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class ModerationRecord extends FirestoreRecord {
  ModerationRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "TITRE" field.
  String? _titre;
  String get titre => _titre ?? '';
  bool hasTitre() => _titre != null;

  // "CONTENU" field.
  String? _contenu;
  String get contenu => _contenu ?? '';
  bool hasContenu() => _contenu != null;

  // "MOTIF" field.
  String? _motif;
  String get motif => _motif ?? '';
  bool hasMotif() => _motif != null;

  // "HEUR" field.
  DateTime? _heur;
  DateTime? get heur => _heur;
  bool hasHeur() => _heur != null;

  // "PAR" field.
  DocumentReference? _par;
  DocumentReference? get par => _par;
  bool hasPar() => _par != null;

  // "AUTEUR" field.
  DocumentReference? _auteur;
  DocumentReference? get auteur => _auteur;
  bool hasAuteur() => _auteur != null;

  void _initializeFields() {
    _titre = snapshotData['TITRE'] as String?;
    _contenu = snapshotData['CONTENU'] as String?;
    _motif = snapshotData['MOTIF'] as String?;
    _heur = snapshotData['HEUR'] as DateTime?;
    _par = snapshotData['PAR'] as DocumentReference?;
    _auteur = snapshotData['AUTEUR'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('MODERATION');

  static Stream<ModerationRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ModerationRecord.fromSnapshot(s));

  static Future<ModerationRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ModerationRecord.fromSnapshot(s));

  static ModerationRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ModerationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ModerationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ModerationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ModerationRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ModerationRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createModerationRecordData({
  String? titre,
  String? contenu,
  String? motif,
  DateTime? heur,
  DocumentReference? par,
  DocumentReference? auteur,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'TITRE': titre,
      'CONTENU': contenu,
      'MOTIF': motif,
      'HEUR': heur,
      'PAR': par,
      'AUTEUR': auteur,
    }.withoutNulls,
  );

  return firestoreData;
}

class ModerationRecordDocumentEquality implements Equality<ModerationRecord> {
  const ModerationRecordDocumentEquality();

  @override
  bool equals(ModerationRecord? e1, ModerationRecord? e2) {
    return e1?.titre == e2?.titre &&
        e1?.contenu == e2?.contenu &&
        e1?.motif == e2?.motif &&
        e1?.heur == e2?.heur &&
        e1?.par == e2?.par &&
        e1?.auteur == e2?.auteur;
  }

  @override
  int hash(ModerationRecord? e) => const ListEquality()
      .hash([e?.titre, e?.contenu, e?.motif, e?.heur, e?.par, e?.auteur]);

  @override
  bool isValidKey(Object? o) => o is ModerationRecord;
}
