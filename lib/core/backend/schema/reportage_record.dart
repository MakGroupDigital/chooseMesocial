import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';
import '/core/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class ReportageRecord extends FirestoreRecord {
  ReportageRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "titre" field.
  String? _titre;
  String get titre => _titre ?? '';
  bool hasTitre() => _titre != null;

  // "video" field.
  String? _video;
  String get video => _video ?? '';
  bool hasVideo() => _video != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "reporteur" field.
  String? _reporteur;
  String get reporteur => _reporteur ?? '';
  bool hasReporteur() => _reporteur != null;

  // "userposteur" field.
  List<DocumentReference>? _userposteur;
  List<DocumentReference> get userposteur => _userposteur ?? const [];
  bool hasUserposteur() => _userposteur != null;

  // "journaliste" field.
  List<DocumentReference>? _journaliste;
  List<DocumentReference> get journaliste => _journaliste ?? const [];
  bool hasJournaliste() => _journaliste != null;

  // "statut" field.
  String? _statut;
  String get statut => _statut ?? '';
  bool hasStatut() => _statut != null;

  // "detail" field.
  String? _detail;
  String get detail => _detail ?? '';
  bool hasDetail() => _detail != null;

  void _initializeFields() {
    _titre = snapshotData['titre'] as String?;
    _video = snapshotData['video'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _reporteur = snapshotData['reporteur'] as String?;
    _userposteur = getDataList(snapshotData['userposteur']);
    _journaliste = getDataList(snapshotData['journaliste']);
    _statut = snapshotData['statut'] as String?;
    _detail = snapshotData['detail'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('reportage');

  static Stream<ReportageRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ReportageRecord.fromSnapshot(s));

  static Future<ReportageRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ReportageRecord.fromSnapshot(s));

  static ReportageRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReportageRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ReportageRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReportageRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReportageRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReportageRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createReportageRecordData({
  String? titre,
  String? video,
  DateTime? date,
  String? reporteur,
  String? statut,
  String? detail,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'titre': titre,
      'video': video,
      'date': date,
      'reporteur': reporteur,
      'statut': statut,
      'detail': detail,
    }.withoutNulls,
  );

  return firestoreData;
}

class ReportageRecordDocumentEquality implements Equality<ReportageRecord> {
  const ReportageRecordDocumentEquality();

  @override
  bool equals(ReportageRecord? e1, ReportageRecord? e2) {
    const listEquality = ListEquality();
    return e1?.titre == e2?.titre &&
        e1?.video == e2?.video &&
        e1?.date == e2?.date &&
        e1?.reporteur == e2?.reporteur &&
        listEquality.equals(e1?.userposteur, e2?.userposteur) &&
        listEquality.equals(e1?.journaliste, e2?.journaliste) &&
        e1?.statut == e2?.statut &&
        e1?.detail == e2?.detail;
  }

  @override
  int hash(ReportageRecord? e) => const ListEquality().hash([
        e?.titre,
        e?.video,
        e?.date,
        e?.reporteur,
        e?.userposteur,
        e?.journaliste,
        e?.statut,
        e?.detail
      ]);

  @override
  bool isValidKey(Object? o) => o is ReportageRecord;
}
