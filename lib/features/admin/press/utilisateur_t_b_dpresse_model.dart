import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/form_field_controller.dart';
import 'utilisateur_t_b_dpresse_widget.dart' show UtilisateurTBDpresseWidget;
import 'package:flutter/material.dart';

class UtilisateurTBDpresseModel
    extends FlutterFlowModel<UtilisateurTBDpresseWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
