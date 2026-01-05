import '/core/flutter_flow/flutter_flow_util.dart';
import 'chat_page_widget.dart' show ChatPageWidget;
import 'package:flutter/material.dart';

class ChatPageModel extends FlutterFlowModel<ChatPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for champmessage widget.
  FocusNode? champmessageFocusNode;
  TextEditingController? champmessageTextController;
  String? Function(BuildContext, String?)? champmessageTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    champmessageFocusNode?.dispose();
    champmessageTextController?.dispose();
  }
}
