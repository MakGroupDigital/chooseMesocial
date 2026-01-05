import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home8_widget.dart' show Home8Widget;
import 'package:flutter/material.dart';

class Home8Model extends FlutterFlowModel<Home8Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
