import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profil_u_tedt_widget.dart' show ProfilUTedtWidget;
import 'package:flutter/material.dart';

class ProfilUTedtModel extends FlutterFlowModel<ProfilUTedtWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataDlp = false;
  FFUploadedFile uploadedLocalFile_uploadDataDlp =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataDlp = '';

  // State field(s) for TextFieldnom widget.
  FocusNode? textFieldnomFocusNode;
  TextEditingController? textFieldnomTextController;
  String? Function(BuildContext, String?)? textFieldnomTextControllerValidator;
  // State field(s) for TextFieldpays widget.
  FocusNode? textFieldpaysFocusNode;
  TextEditingController? textFieldpaysTextController;
  String? Function(BuildContext, String?)? textFieldpaysTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldnomFocusNode?.dispose();
    textFieldnomTextController?.dispose();

    textFieldpaysFocusNode?.dispose();
    textFieldpaysTextController?.dispose();
  }
}
