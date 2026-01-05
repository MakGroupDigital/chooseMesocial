import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'searche_talent_widget.dart' show SearcheTalentWidget;
import 'package:flutter/material.dart';

class SearcheTalentModel extends FlutterFlowModel<SearcheTalentWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
