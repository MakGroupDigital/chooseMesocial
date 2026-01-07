import 'dart:async';

import 'package:collection/collection.dart';

import '/core/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/core/flutter_flow/flutter_flow_util.dart';

class MatchRecord extends FirestoreRecord {
  MatchRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "external_id" field.
  String? _externalId;
  String get externalId => _externalId ?? '';
  bool hasExternalId() => _externalId != null;

  // "team_a_name" field.
  String? _teamAName;
  String get teamAName => _teamAName ?? '';
  bool hasTeamAName() => _teamAName != null;

  // "team_a_logo" field.
  String? _teamALogo;
  String get teamALogo => _teamALogo ?? '';
  bool hasTeamALogo() => _teamALogo != null;

  // "team_b_name" field.
  String? _teamBName;
  String get teamBName => _teamBName ?? '';
  bool hasTeamBName() => _teamBName != null;

  // "team_b_logo" field.
  String? _teamBLogo;
  String get teamBLogo => _teamBLogo ?? '';
  bool hasTeamBLogo() => _teamBLogo != null;

  // "competition" field.
  String? _competition;
  String get competition => _competition ?? '';
  bool hasCompetition() => _competition != null;

  // "start_time" field.
  DateTime? _startTime;
  DateTime? get startTime => _startTime;
  bool hasStartTime() => _startTime != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "score_a" field.
  int? _scoreA;
  int get scoreA => _scoreA ?? 0;
  bool hasScoreA() => _scoreA != null;

  // "score_b" field.
  int? _scoreB;
  int get scoreB => _scoreB ?? 0;
  bool hasScoreB() => _scoreB != null;

  // "match_minute" field.
  int? _matchMinute;
  int get matchMinute => _matchMinute ?? 0;
  bool hasMatchMinute() => _matchMinute != null;

  // "predictions_enabled" field.
  bool? _predictionsEnabled;
  bool get predictionsEnabled => _predictionsEnabled ?? true;
  bool hasPredictionsEnabled() => _predictionsEnabled != null;

  // "reward_amount" field.
  double? _rewardAmount;
  double get rewardAmount => _rewardAmount ?? 0.0;
  bool hasRewardAmount() => _rewardAmount != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  void _initializeFields() {
    _externalId = snapshotData['external_id'] as String?;
    _teamAName = snapshotData['team_a_name'] as String?;
    _teamALogo = snapshotData['team_a_logo'] as String?;
    _teamBName = snapshotData['team_b_name'] as String?;
    _teamBLogo = snapshotData['team_b_logo'] as String?;
    _competition = snapshotData['competition'] as String?;
    _startTime = snapshotData['start_time'] as DateTime?;
    _status = snapshotData['status'] as String?;
    _scoreA = castToType<int>(snapshotData['score_a']);
    _scoreB = castToType<int>(snapshotData['score_b']);
    _matchMinute = castToType<int>(snapshotData['match_minute']);
    _predictionsEnabled = snapshotData['predictions_enabled'] as bool?;
    _rewardAmount = castToType<double>(snapshotData['reward_amount']);
    _createdAt = snapshotData['created_at'] as DateTime?;
    _updatedAt = snapshotData['updated_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('matches');

  static Stream<MatchRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MatchRecord.fromSnapshot(s));

  static Future<MatchRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MatchRecord.fromSnapshot(s));

  static MatchRecord fromSnapshot(DocumentSnapshot snapshot) => MatchRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MatchRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MatchRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MatchRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MatchRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMatchRecordData({
  String? externalId,
  String? teamAName,
  String? teamALogo,
  String? teamBName,
  String? teamBLogo,
  String? competition,
  DateTime? startTime,
  String? status,
  int? scoreA,
  int? scoreB,
  int? matchMinute,
  bool? predictionsEnabled,
  double? rewardAmount,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'external_id': externalId,
      'team_a_name': teamAName,
      'team_a_logo': teamALogo,
      'team_b_name': teamBName,
      'team_b_logo': teamBLogo,
      'competition': competition,
      'start_time': startTime,
      'status': status,
      'score_a': scoreA,
      'score_b': scoreB,
      'match_minute': matchMinute,
      'predictions_enabled': predictionsEnabled,
      'reward_amount': rewardAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class MatchRecordDocumentEquality implements Equality<MatchRecord> {
  const MatchRecordDocumentEquality();

  @override
  bool equals(MatchRecord? e1, MatchRecord? e2) {
    return e1?.externalId == e2?.externalId &&
        e1?.teamAName == e2?.teamAName &&
        e1?.teamALogo == e2?.teamALogo &&
        e1?.teamBName == e2?.teamBName &&
        e1?.teamBLogo == e2?.teamBLogo &&
        e1?.competition == e2?.competition &&
        e1?.startTime == e2?.startTime &&
        e1?.status == e2?.status &&
        e1?.scoreA == e2?.scoreA &&
        e1?.scoreB == e2?.scoreB &&
        e1?.matchMinute == e2?.matchMinute &&
        e1?.predictionsEnabled == e2?.predictionsEnabled &&
        e1?.rewardAmount == e2?.rewardAmount &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt;
  }

  @override
  int hash(MatchRecord? e) => const ListEquality().hash([
        e?.externalId,
        e?.teamAName,
        e?.teamALogo,
        e?.teamBName,
        e?.teamBLogo,
        e?.competition,
        e?.startTime,
        e?.status,
        e?.scoreA,
        e?.scoreB,
        e?.matchMinute,
        e?.predictionsEnabled,
        e?.rewardAmount,
        e?.createdAt,
        e?.updatedAt
      ]);

  @override
  bool isValidKey(Object? o) => o is MatchRecord;
}