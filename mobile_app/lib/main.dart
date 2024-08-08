//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mobile_app/web_view_container.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const WebviewExample(),
      '/webViewContainer': (context) => const WebViewContainer()
    },
  )
);

class WebviewExample extends StatefulWidget {
  const WebviewExample({Key? key}) : super(key: key);

  @override
  State<WebviewExample> createState() => _WebviewExampleState();
}

class _WebviewExampleState extends State<WebviewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview Example'),
      ),
      body: content()
    );
  }

  Widget content() {
    return Center(
      child : ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/webViewContainer');
        },
        child: const Text('Open Webview'),
      ),
    );
  }
}