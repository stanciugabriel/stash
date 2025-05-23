import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsOfUse {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (builder) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: WebViewWidget(
            controller: WebViewController()
              ..loadRequest(
                Uri.parse('https://tos.stashapp.ro'),
              ),
          ),
        );
      },
    );
  }
}
