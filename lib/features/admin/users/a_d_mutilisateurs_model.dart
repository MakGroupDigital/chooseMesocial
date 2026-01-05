import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'a_d_mutilisateurs_widget.dart' show ADMutilisateursWidget;
import 'package:flutter/material.dart';

class ADMutilisateursModel extends FlutterFlowModel<ADMutilisateursWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
