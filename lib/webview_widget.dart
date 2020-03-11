import 'dart:async';

import 'package:flutter/material.dart';
import "package:flutter_webview_plugin/flutter_webview_plugin.dart";
import 'package:pharmacy_app/server_wrapper.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';

class WebViewWidget extends StatefulWidget{
  final url;

  const WebViewWidget({Key key, this.url}) : super(key: key);

  _WebViewWidgetState createState() => _WebViewWidgetState();

}

class _WebViewWidgetState extends State<WebViewWidget>{
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      var uri = Uri.parse(url);
      var query = uri.queryParameters;
      if (query["code"] != null){
        postEsiaAndClose(query['code'], query['state']);
      }
    });

    /*_onStateChanged = flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      var uri = Uri.parse(state.url);
      uri.queryParameters.forEach((k, v) {
        print('key: $k - value: $v');
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      clearCache: true,
      clearCookies: true,
      appCacheEnabled: false,
      hidden: true,
      url: widget.url,
      appBar: AppBar(
        title: Text('Вход через "Госуслуги"'),
      ),
    );
  }

  void postEsiaAndClose(String code, String state) async {
    await ServerLogin.postDataFromEsia(code, state);
    Navigator.of(context).pushNamedAndRemoveUntil("/MyProfile", ModalRoute.withName('/'), arguments: false);
    print("Successful posted data");
  }
}