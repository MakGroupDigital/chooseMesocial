import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'connexion_widget.dart' show ConnexionWidget;
import 'package:flutter/material.dart';

class ConnexionModel extends FlutterFlowModel<ConnexionWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextFieldmail widget.
  FocusNode? textFieldmailFocusNode;
  TextEditingController? textFieldmailTextController;
  String? Function(BuildContext, String?)? textFieldmailTextControllerValidator;
  // State field(s) for TextFieldcode widget.
  FocusNode? textFieldcodeFocusNode;
  TextEditingController? textFieldcodeTextController;
  late bool textFieldcodeVisibility;
  String? Function(BuildContext, String?)? textFieldcodeTextControllerValidator;

  @override
  void initState(BuildContext context) {
    textFieldcodeVisibility = false;
  }

  @override
  void dispose() {
    textFieldmailFocusNode?.dispose();
    textFieldmailTextController?.dispose();

    textFieldcodeFocusNode?.dispose();
    textFieldcodeTextController?.dispose();
  }
}
