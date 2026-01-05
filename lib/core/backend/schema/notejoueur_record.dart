import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';
import '/core/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class NotejoueurRecord extends FirestoreRecord {
  NotejoueurRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "nomjoueur" field.
  List<DocumentReference>? _nomjoueur;
  List<DocumentReference> get nomjoueur => _nomjoueur ?? const [];
  bool hasNomjoueur() => _nomjoueur != null;

  // "etoile" field.
  double? _etoile;
  double get etoile => _etoile ?? 0.0;
  bool hasEtoile() => _etoile != null;

  // "analises" field.
  String? _analises;
  String get analises => _analises ?? '';
  bool hasAnalises() => _analises != null;

  // "observation" field.
  String? _observation;
  String get observation => _observation ?? '';
  bool hasObservation() => _observation != null;

  // "amelioration" field.
  String? _amelioration;
  String get amelioration => _amelioration ?? '';
  bool hasAmelioration() => _amelioration != null;

  // "idrefjoueur" field.
  DocumentReference? _idrefjoueur;
  DocumentReference? get idrefjoueur => _idrefjoueur;
  bool hasIdrefjoueur() => _idrefjoueur != null;

  // "idauteur" field.
  DocumentReference? _idauteur;
  DocumentReference? get idauteur => _idauteur;
  bool hasIdauteur() => _idauteur != null;

  // "udauteurjournaliste" field.
  List<DocumentReference>? _udauteurjournaliste;
  List<DocumentReference> get udauteurjournaliste =>
      _udauteurjournaliste ?? const [];
  bool hasUdauteurjournaliste() => _udauteurjournaliste != null;

  void _initializeFields() {
    _nomjoueur = getDataList(snapshotData['nomjoueur']);
    _etoile = castToType<double>(snapshotData['etoile']);
    _analises = snapshotData['analises'] as String?;
    _observation = snapshotData['observation'] as String?;
    _amelioration = snapshotData['amelioration'] as String?;
    _idrefjoueur = snapshotData['idrefjoueur'] as DocumentReference?;
    _idauteur = snapshotData['idauteur'] as DocumentReference?;
    _udauteurjournaliste = getDataList(snapshotData['udauteurjournaliste']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notejoueur');

  static Stream<NotejoueurRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotejoueurRecord.fromSnapshot(s));

  static Future<NotejoueurRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotejoueurRecord.fromSnapshot(s));

  static NotejoueurRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotejoueurRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotejoueurRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotejoueurRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotejoueurRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotejoueurRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotejoueurRecordData({
  double? etoile,
  String? analises,
  String? observation,
  String? amelioration,
  DocumentReference? idrefjoueur,
  DocumentReference? idauteur,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'etoile': etoile,
      'analises': analises,
      'observation': observation,
      'amelioration': amelioration,
      'idrefjoueur': idrefjoueur,
      'idauteur': idauteur,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotejoueurRecordDocumentEquality implements Equality<NotejoueurRecord> {
  const NotejoueurRecordDocumentEquality();

  @override
  bool equals(NotejoueurRecord? e1, NotejoueurRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.nomjoueur, e2?.nomjoueur) &&
        e1?.etoile == e2?.etoile &&
        e1?.analises == e2?.analises &&
        e1?.observation == e2?.observation &&
        e1?.amelioration == e2?.amelioration &&
        e1?.idrefjoueur == e2?.idrefjoueur &&
        e1?.idauteur == e2?.idauteur &&
        listEquality.equals(e1?.udauteurjournaliste, e2?.udauteurjournaliste);
  }

  @override
  int hash(NotejoueurRecord? e) => const ListEquality().hash([
        e?.nomjoueur,
        e?.etoile,
        e?.analises,
        e?.observation,
        e?.amelioration,
        e?.idrefjoueur,
        e?.idauteur,
        e?.udauteurjournaliste
      ]);

  @override
  bool isValidKey(Object? o) => o is NotejoueurRecord;
}
