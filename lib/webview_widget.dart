import 'package:flutter/material.dart';
import "package:flutter_webview_plugin/flutter_webview_plugin.dart";

class WebViewWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WebviewScaffold(
      hidden: true,
      url: "https://009.am",
      appBar: AppBar(
        title: Text("WebView test"),
      ),
    );
  }

}