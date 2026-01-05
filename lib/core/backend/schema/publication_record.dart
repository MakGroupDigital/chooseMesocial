import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';
import '/core/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class PublicationRecord extends FirestoreRecord {
  PublicationRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "post_photo" field.
  String? _postPhoto;
  String get postPhoto => _postPhoto ?? '';
  bool hasPostPhoto() => _postPhoto != null;

  // "post_title" field.
  String? _postTitle;
  String get postTitle => _postTitle ?? '';
  bool hasPostTitle() => _postTitle != null;

  // "post_description" field.
  String? _postDescription;
  String get postDescription => _postDescription ?? '';
  bool hasPostDescription() => _postDescription != null;

  // "post_user" field.
  DocumentReference? _postUser;
  DocumentReference? get postUser => _postUser;
  bool hasPostUser() => _postUser != null;

  // "time_posted" field.
  DateTime? _timePosted;
  DateTime? get timePosted => _timePosted;
  bool hasTimePosted() => _timePosted != null;

  // "likes" field.
  List<DocumentReference>? _likes;
  List<DocumentReference> get likes => _likes ?? const [];
  bool hasLikes() => _likes != null;

  // "num_comments" field.
  int? _numComments;
  int get numComments => _numComments ?? 0;
  bool hasNumComments() => _numComments != null;

  // "num_votes" field.
  int? _numVotes;
  int get numVotes => _numVotes ?? 0;
  bool hasNumVotes() => _numVotes != null;

  // "sporttype" field.
  String? _sporttype;
  String get sporttype => _sporttype ?? '';
  bool hasSporttype() => _sporttype != null;

  // "postVido" field.
  String? _postVido;
  String get postVido => _postVido ?? '';
  bool hasPostVido() => _postVido != null;

  // "ashtag" field.
  String? _ashtag;
  String get ashtag => _ashtag ?? '';
  bool hasAshtag() => _ashtag != null;

  // "userpost" field.
  DocumentReference? _userpost;
  DocumentReference? get userpost => _userpost;
  bool hasUserpost() => _userpost != null;

  // "nomPoster" field.
  String? _nomPoster;
  String get nomPoster => _nomPoster ?? '';
  bool hasNomPoster() => _nomPoster != null;

  // "whatsapp" field.
  DocumentReference? _whatsapp;
  DocumentReference? get whatsapp => _whatsapp;
  bool hasWhatsapp() => _whatsapp != null;

  // "whatsa" field.
  List<DocumentReference>? _whatsa;
  List<DocumentReference> get whatsa => _whatsa ?? const [];
  bool hasWhatsa() => _whatsa != null;

  // "type" field.
  List<String>? _type;
  List<String> get type => _type ?? const [];
  bool hasType() => _type != null;

  // "atype" field.
  DocumentReference? _atype;
  DocumentReference? get atype => _atype;
  bool hasAtype() => _atype != null;

  // "top" field.
  String? _top;
  String get top => _top ?? '';
  bool hasTop() => _top != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _postPhoto = snapshotData['post_photo'] as String?;
    _postTitle = snapshotData['post_title'] as String?;
    _postDescription = snapshotData['post_description'] as String?;
    _postUser = snapshotData['post_user'] as DocumentReference?;
    _timePosted = snapshotData['time_posted'] as DateTime?;
    _likes = getDataList(snapshotData['likes']);
    _numComments = castToType<int>(snapshotData['num_comments']);
    _numVotes = castToType<int>(snapshotData['num_votes']);
    _sporttype = snapshotData['sporttype'] as String?;
    _postVido = snapshotData['postVido'] as String?;
    _ashtag = snapshotData['ashtag'] as String?;
    _userpost = snapshotData['userpost'] as DocumentReference?;
    _nomPoster = snapshotData['nomPoster'] as String?;
    _whatsapp = snapshotData['whatsapp'] as DocumentReference?;
    _whatsa = getDataList(snapshotData['whatsa']);
    _type = getDataList(snapshotData['type']);
    _atype = snapshotData['atype'] as DocumentReference?;
    _top = snapshotData['top'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('publication')
          : FirebaseFirestore.instance.collectionGroup('publication');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('publication').doc(id);

  static Stream<PublicationRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PublicationRecord.fromSnapshot(s));

  static Future<PublicationRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PublicationRecord.fromSnapshot(s));

  static PublicationRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PublicationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PublicationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PublicationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PublicationRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PublicationRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPublicationRecordData({
  String? postPhoto,
  String? postTitle,
  String? postDescription,
  DocumentReference? postUser,
  DateTime? timePosted,
  int? numComments,
  int? numVotes,
  String? sporttype,
  String? postVido,
  String? ashtag,
  DocumentReference? userpost,
  String? nomPoster,
  DocumentReference? whatsapp,
  DocumentReference? atype,
  String? top,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'post_photo': postPhoto,
      'post_title': postTitle,
      'post_description': postDescription,
      'post_user': postUser,
      'time_posted': timePosted,
      'num_comments': numComments,
      'num_votes': numVotes,
      'sporttype': sporttype,
      'postVido': postVido,
      'ashtag': ashtag,
      'userpost': userpost,
      'nomPoster': nomPoster,
      'whatsapp': whatsapp,
      'atype': atype,
      'top': top,
    }.withoutNulls,
  );

  return firestoreData;
}

class PublicationRecordDocumentEquality implements Equality<PublicationRecord> {
  const PublicationRecordDocumentEquality();

  @override
  bool equals(PublicationRecord? e1, PublicationRecord? e2) {
    const listEquality = ListEquality();
    return e1?.postPhoto == e2?.postPhoto &&
        e1?.postTitle == e2?.postTitle &&
        e1?.postDescription == e2?.postDescription &&
        e1?.postUser == e2?.postUser &&
        e1?.timePosted == e2?.timePosted &&
        listEquality.equals(e1?.likes, e2?.likes) &&
        e1?.numComments == e2?.numComments &&
        e1?.numVotes == e2?.numVotes &&
        e1?.sporttype == e2?.sporttype &&
        e1?.postVido == e2?.postVido &&
        e1?.ashtag == e2?.ashtag &&
        e1?.userpost == e2?.userpost &&
        e1?.nomPoster == e2?.nomPoster &&
        e1?.whatsapp == e2?.whatsapp &&
        listEquality.equals(e1?.whatsa, e2?.whatsa) &&
        listEquality.equals(e1?.type, e2?.type) &&
        e1?.atype == e2?.atype &&
        e1?.top == e2?.top;
  }

  @override
  int hash(PublicationRecord? e) => const ListEquality().hash([
        e?.postPhoto,
        e?.postTitle,
        e?.postDescription,
        e?.postUser,
        e?.timePosted,
        e?.likes,
        e?.numComments,
        e?.numVotes,
        e?.sporttype,
        e?.postVido,
        e?.ashtag,
        e?.userpost,
        e?.nomPoster,
        e?.whatsapp,
        e?.whatsa,
        e?.type,
        e?.atype,
        e?.top
      ]);

  @override
  bool isValidKey(Object? o) => o is PublicationRecord;
}
