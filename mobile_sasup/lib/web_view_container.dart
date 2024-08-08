import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  const WebViewContainer({Key? key}) : super(key: key);

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('http://10.0.2.2:5000/uploads/page1.html'));
  final controller2 = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('http://10.0.2.2:5000/uploads/page2.html'));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              size: 40,
              Icons.arrow_circle_left_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Center(
            child: Text('Alimentação'),
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30,
                child: Icon(
                  size: 30,
                  Icons.map_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  child: Text("ALIMENTAÇÃO"),
                ),
                Tab(
                  child: Text("UNIDADES"),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  WebViewWidget(controller: controller),
                  WebViewWidget(controller: controller2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
