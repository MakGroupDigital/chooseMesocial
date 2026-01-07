import '/core/flutter_flow/flutter_flow_util.dart';
import '/core/flutter_flow/form_field_controller.dart';
import 'withdrawal_widget.dart' show WithdrawalWidget;
import 'package:flutter/material.dart';

class WithdrawalModel extends FlutterFlowModel<WithdrawalWidget> {
  /// State fields for stateful widgets in this page.

  // State field(s) for amount widget.
  FocusNode? amountFocusNode;
  TextEditingController? amountTextController;
  String? Function(BuildContext, String?)? amountTextControllerValidator;

  // State field(s) for method dropdown.
  String? selectedMethod;
  FormFieldController<String>? methodValueController;

  // State field(s) for phone widget.
  FocusNode? phoneFocusNode;
  TextEditingController? phoneTextController;
  String? Function(BuildContext, String?)? phoneTextControllerValidator;

  // État de soumission
  bool isSubmitting = false;
  
  // Message d'erreur
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    amountFocusNode?.dispose();
    amountTextController?.dispose();

    phoneFocusNode?.dispose();
    phoneTextController?.dispose();
  }
}