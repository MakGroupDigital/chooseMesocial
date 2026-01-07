import '/core/flutter_flow/flutter_flow_util.dart';
import 'match_detail_widget.dart' show MatchDetailWidget;
import 'package:flutter/material.dart';

class MatchDetailModel extends FlutterFlowModel<MatchDetailWidget> {
  /// State fields for stateful widgets in this page.

  // État de soumission du pronostic
  bool isSubmitting = false;
  
  // Message d'erreur
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}