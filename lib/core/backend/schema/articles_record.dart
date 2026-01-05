import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';
import '/core/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class ArticlesRecord extends FirestoreRecord {
  ArticlesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "titreArticle" field.
  String? _titreArticle;
  String get titreArticle => _titreArticle ?? '';
  bool hasTitreArticle() => _titreArticle != null;

  // "descriptionArticle" field.
  String? _descriptionArticle;
  String get descriptionArticle => _descriptionArticle ?? '';
  bool hasDescriptionArticle() => _descriptionArticle != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "images" field.
  String? _images;
  String get images => _images ?? '';
  bool hasImages() => _images != null;

  // "motcles" field.
  String? _motcles;
  String get motcles => _motcles ?? '';
  bool hasMotcles() => _motcles != null;

  // "idauteur" field.
  List<DocumentReference>? _idauteur;
  List<DocumentReference> get idauteur => _idauteur ?? const [];
  bool hasIdauteur() => _idauteur != null;

  // "nomautheur" field.
  DocumentReference? _nomautheur;
  DocumentReference? get nomautheur => _nomautheur;
  bool hasNomautheur() => _nomautheur != null;

  // "jourevenement" field.
  String? _jourevenement;
  String get jourevenement => _jourevenement ?? '';
  bool hasJourevenement() => _jourevenement != null;

  // "categorie" field.
  String? _categorie;
  String get categorie => _categorie ?? '';
  bool hasCategorie() => _categorie != null;

  // "nomjournaliste" field.
  String? _nomjournaliste;
  String get nomjournaliste => _nomjournaliste ?? '';
  bool hasNomjournaliste() => _nomjournaliste != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _titreArticle = snapshotData['titreArticle'] as String?;
    _descriptionArticle = snapshotData['descriptionArticle'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _images = snapshotData['images'] as String?;
    _motcles = snapshotData['motcles'] as String?;
    _idauteur = getDataList(snapshotData['idauteur']);
    _nomautheur = snapshotData['nomautheur'] as DocumentReference?;
    _jourevenement = snapshotData['jourevenement'] as String?;
    _categorie = snapshotData['categorie'] as String?;
    _nomjournaliste = snapshotData['nomjournaliste'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('articles')
          : FirebaseFirestore.instance.collectionGroup('articles');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('articles').doc(id);

  static Stream<ArticlesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ArticlesRecord.fromSnapshot(s));

  static Future<ArticlesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ArticlesRecord.fromSnapshot(s));

  static ArticlesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ArticlesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ArticlesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ArticlesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ArticlesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ArticlesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createArticlesRecordData({
  String? titreArticle,
  String? descriptionArticle,
  DateTime? date,
  String? images,
  String? motcles,
  DocumentReference? nomautheur,
  String? jourevenement,
  String? categorie,
  String? nomjournaliste,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'titreArticle': titreArticle,
      'descriptionArticle': descriptionArticle,
      'date': date,
      'images': images,
      'motcles': motcles,
      'nomautheur': nomautheur,
      'jourevenement': jourevenement,
      'categorie': categorie,
      'nomjournaliste': nomjournaliste,
    }.withoutNulls,
  );

  return firestoreData;
}

class ArticlesRecordDocumentEquality implements Equality<ArticlesRecord> {
  const ArticlesRecordDocumentEquality();

  @override
  bool equals(ArticlesRecord? e1, ArticlesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.titreArticle == e2?.titreArticle &&
        e1?.descriptionArticle == e2?.descriptionArticle &&
        e1?.date == e2?.date &&
        e1?.images == e2?.images &&
        e1?.motcles == e2?.motcles &&
        listEquality.equals(e1?.idauteur, e2?.idauteur) &&
        e1?.nomautheur == e2?.nomautheur &&
        e1?.jourevenement == e2?.jourevenement &&
        e1?.categorie == e2?.categorie &&
        e1?.nomjournaliste == e2?.nomjournaliste;
  }

  @override
  int hash(ArticlesRecord? e) => const ListEquality().hash([
        e?.titreArticle,
        e?.descriptionArticle,
        e?.date,
        e?.images,
        e?.motcles,
        e?.idauteur,
        e?.nomautheur,
        e?.jourevenement,
        e?.categorie,
        e?.nomjournaliste
      ]);

  @override
  bool isValidKey(Object? o) => o is ArticlesRecord;
}
