import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pi_mobile/login_page.dart';
import 'package:pi_mobile/profile.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

StreamController<bool> isLightTheme = StreamController();
StreamController<int> themeColor = StreamController();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: true,
      stream: isLightTheme.stream,
      builder: (context, snapshot1) {
        return StreamBuilder<int>(
          initialData: 0,
          stream: themeColor.stream,
          builder: (context, snapshot2) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'PI mobile app',
              theme: ThemeData(
                useMaterial3: false,
                brightness:
                    snapshot1.data! ? Brightness.light : Brightness.dark,
                primarySwatch: snapshot2.data! == 0
                    ? Colors.green
                    : snapshot2.data! == 1
                        ? Colors.orange
                        : Colors.purple,
              ),
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const MyHomePage();
                  } else {
                    return const LoginPage();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> pageNames = [];
  String selectedPageName = '';

  Future<void> fetchPageNames() async {
    try {
      var url = Uri.parse('http://10.0.2.2:5000/uploads');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          pageNames = List<String>.from(jsonDecode(response.body)
              .map((item) => (item as String).replaceAll('.html', '')));
          if (pageNames.isNotEmpty && selectedPageName == '') {
            selectedPageName = pageNames.first;
          }
        });
      } else {
        print('Failed to fetch page names: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching page names: $e');
    }
  }

  Future<void> approveFile(String fileName) async {
    final url = Uri.parse('http://10.0.2.2:5000/approve');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'filename': fileName}),
    );

    if (response.statusCode == 200) {
      print('File approved successfully');
    } else {
      print('Failed to approve file: ${response.statusCode}');
    }
  }

  Icon view = const Icon(
    Icons.phone_android,
    color: Colors.grey,
    size: 30,
  );
  Icon brightness = const Icon(
    Icons.mode_night_outlined,
    color: Colors.grey,
    size: 30,
  );
  int checkV = 1;
  int checkB = 0;
  int colorN = 0;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  final webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..enableZoom(true);

  final webViewControllerD = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..enableZoom(true)
    ..setUserAgent(
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36");

  @override
  void initState() {
    fetchPageNames().then((value) {
      webViewController.loadRequest(
          Uri.parse("http://10.0.2.2:5000/uploads/$selectedPageName.html"));
      webViewControllerD.loadRequest(
          Uri.parse("http://10.0.2.2:5000/uploads/$selectedPageName.html"));
    });
    Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchPageNames().then((value) {
        if (selectedPageName == "results") {
          webViewController.loadRequest(
              Uri.parse("http://10.0.2.2:5000/results/$selectedPageName.html"));
          webViewControllerD.loadRequest(
              Uri.parse("http://10.0.2.2:5000/results/$selectedPageName.html"));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
              ),
            );
          },
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(_createRoute()),
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 40,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FittedBox(
          child: FloatingActionButton.large(
            onPressed: () {
              setState(
                () {
                  approveFile(selectedPageName).then((value) {
                    fetchPageNames().then((value) {});
                  });
                },
              );
            },
            child:
                const Icon(Icons.check_rounded, color: Colors.white, size: 60),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: pageNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          pageNames[index],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectedPageName = pageNames[index];
                          });
                          webViewController.loadRequest(Uri.parse(
                              "http://10.0.2.2:5000/uploads/$selectedPageName.html"));
                          webViewControllerD.loadRequest(Uri.parse(
                              "http://10.0.2.2:5000/uploads/$selectedPageName.html"));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap:  () {
                Navigator.pop(context);
                setState(() {
                  selectedPageName = "results";
                });
                webViewController.loadRequest(Uri.parse(
                    "http://10.0.2.2:5000/results/$selectedPageName.html"));
                webViewControllerD.loadRequest(Uri.parse(
                    "http://10.0.2.2:5000/results/$selectedPageName.html"));
              }, //logout
              child: const Text(
                "Form results",
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: signUserOut, //logout
              child: const Text(
                "Log Out",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  if (checkV == 0)
                    Positioned.fill(
                      child: WebViewWidget(controller: webViewControllerD),
                    ),
                  if (checkV != 0)
                    Positioned.fill(
                      child: WebViewWidget(controller: webViewController),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {
                            if (checkV == 0) {
                              setState(() {
                                view = const Icon(Icons.phone_android,
                                    color: Colors.grey, size: 30);
                                checkV = 1;
                              });
                            } else {
                              setState(() {
                                view = const Icon(Icons.computer,
                                    color: Colors.grey, size: 30);
                                checkV = 0;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(7)),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 3,
                                  strokeAlign: BorderSide.strokeAlignOutside),
                            ),
                            child: Center(
                              child: view,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (checkB == 0) {
                              setState(() {
                                brightness = const Icon(Icons.wb_sunny_outlined,
                                    color: Colors.grey, size: 30);
                                checkB = 1;
                                isLightTheme.add(false);
                              });
                            } else {
                              setState(() {
                                brightness = const Icon(
                                    Icons.mode_night_outlined,
                                    color: Colors.grey,
                                    size: 30);
                                checkB = 0;
                                isLightTheme.add(true);
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 3,
                                  strokeAlign: BorderSide.strokeAlignOutside),
                            ),
                            child: Center(
                              child: brightness,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            themeColor.add(color());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(7)),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 3,
                                  strokeAlign: BorderSide.strokeAlignOutside),
                            ),
                            child: const Center(
                              child: Icon(Icons.palette_outlined,
                                  color: Colors.grey, size: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int color() {
    if (colorN < 2) {
      colorN += 1;
    } else {
      colorN = 0;
    }
    return colorN;
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => const Profile(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
