import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'creat_widget.dart' show CreatWidget;
import 'package:flutter/material.dart';

class CreatModel extends FlutterFlowModel<CreatWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for nom widget.
  FocusNode? nomFocusNode;
  TextEditingController? nomTextController;
  String? Function(BuildContext, String?)? nomTextControllerValidator;
  // State field(s) for mail widget.
  FocusNode? mailFocusNode;
  TextEditingController? mailTextController;
  String? Function(BuildContext, String?)? mailTextControllerValidator;
  // State field(s) for codepays widget.
  String? codepaysValue;
  FormFieldController<String>? codepaysValueController;
  // State field(s) for tel widget.
  FocusNode? telFocusNode;
  TextEditingController? telTextController;
  String? Function(BuildContext, String?)? telTextControllerValidator;
  // State field(s) for code widget.
  FocusNode? codeFocusNode;
  TextEditingController? codeTextController;
  late bool codeVisibility;
  String? Function(BuildContext, String?)? codeTextControllerValidator;
  // State field(s) for confirme widget.
  FocusNode? confirmeFocusNode;
  TextEditingController? confirmeTextController;
  late bool confirmeVisibility;
  String? Function(BuildContext, String?)? confirmeTextControllerValidator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for pays widget.
  String? paysValue;
  FormFieldController<String>? paysValueController;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    codeVisibility = false;
    confirmeVisibility = false;
  }

  @override
  void dispose() {
    nomFocusNode?.dispose();
    nomTextController?.dispose();

    mailFocusNode?.dispose();
    mailTextController?.dispose();

    telFocusNode?.dispose();
    telTextController?.dispose();

    codeFocusNode?.dispose();
    codeTextController?.dispose();

    confirmeFocusNode?.dispose();
    confirmeTextController?.dispose();
  }
}
