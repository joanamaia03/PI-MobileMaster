import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:cms_apps_mobile/models/BoldTextBox.dart';
import 'package:cms_apps_mobile/models/SubmitButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_options.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'login.dart';
import 'models/Block.dart';
import 'models/FormBox.dart';
import 'models/Image.dart';
import 'models/TextBox.dart';
import 'models/ThreeButtons.dart';
import 'models/TwoButtons.dart';

StreamController<bool> isLightTheme = StreamController();
StreamController<int> themeColor = StreamController();

extension ColorExtension on Color {
    String toCssString() {
      return 'rgba(${this.red}, ${this.green}, ${this.blue}, ${this.opacity})';
    }
  }


// Define the ScreenElement class to represent elements stored in Firestore
class ScreenElement {
  final String elementType;
  final String elementText;
  final String key;

  ScreenElement(this.elementType, this.elementText) : key = Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'type': elementType,
      'text': elementText,
      'key': key,
    };
  }

  factory ScreenElement.fromMap(Map<String, dynamic> map) {
    return ScreenElement(
      map['type'] as String,
      map['text'] as String,
    );
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBgzOQcDFFM3YOmYYHZvH9Le9eqpgjwGgI",
        authDomain: "mobilemaster-9c47b.firebaseapp.com",
        projectId: "mobilemaster-9c47b",
        storageBucket: "mobilemaster-9c47b.appspot.com",
        messagingSenderId: "396689703219",
        appId: "1:396689703219:web:bb6f7d83f8df7d2d913e46"),
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
                title: 'MobileMaster',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: snapshot2.data! == 0
                        ? Colors.green
                        : snapshot2.data! == 1
                        ? Colors.orange
                        : Colors.purple,
                    backgroundColor: snapshot2.data! == 0 && snapshot1.data!
                        ? Colors.lightGreen[100]
                        : snapshot2.data! == 1 && snapshot1.data!
                        ? Colors.orange[100]
                        : snapshot2.data! == 2 && snapshot1.data!
                        ? Colors.purple[100]
                        : Colors.black87,
                  ),
                  useMaterial3: true,
                ),
                home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return const MyHomePage(title: 'Flutter Demo Home Page');
                    } else {
                      return const LoginScreen();
                    }
                  },
                ) ,
              );
            },
          );
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  final Logger _logger = Logger('_MyHomePageState');
  List<Block> screenElements = [];
  List<Widget> properties = [];
  List<File> localImages = [];
  List<Uint8List> webImages = [];
  List<Widget> imageOptions = [];
  int globalCount = 0;
  final scrollController = ScrollController();
  List<String> pageNames = [];
  String selectedPageName = '';
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
  bool showApplyButton = false;
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  void loadProperties(Block current) async {
    //List<Widget> properties_ = await current.getProperties();
    setState(() {
      //properties = properties_;
    });
  }

  @override
  void initState() {
    super.initState();
    imageOptions.add(ElevatedButton(onPressed: ()  => _pickImageFromGallery(), child: const Text("Image")));
    fetchPageNames();
  }

  Future<void> fetchPageNames() async {
    try {
      var url = Uri.parse('http://127.0.0.1:5000/uploads');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          pageNames = List<String>.from(jsonDecode(response.body)
              .map((item) => (item as String).replaceAll('.html', '')));
          if (pageNames.isNotEmpty) {
            selectedPageName =
                pageNames.first; // Select the first page by default
          }
        });
      } else {
        print('Failed to fetch page names: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching page names: $e');
    }
  }

  String generateHTMLFromWidgets(List<Block> widgets) {
    StringBuffer htmlBuffer = StringBuffer();

    htmlBuffer.write("<!DOCTYPE html>");
    htmlBuffer.write("<html lang='en'>");
    htmlBuffer.write("<head>");
    htmlBuffer.write("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
    htmlBuffer.write("<meta charset='UTF-8'>");
    htmlBuffer.write("<title>Generated Page</title>");
    htmlBuffer.write("<style>");
    htmlBuffer.write("body { font-family: Arial, sans-serif; padding: 20px; }");
    htmlBuffer.write(".container { margin: 10px 0; padding: 10px; border: 1px solid #ccc; width: 100%; box-sizing: border-box;}");
    htmlBuffer.write(".text-field { padding: 5px; width: 100%; box-sizing: border-box; word-wrap: break-word; overflow: hidden; white-space: normal;}");
    htmlBuffer.write("img { max-width: 100%; height: auto; display: block; margin: 0 auto; }");
    htmlBuffer.write("</style>");
    htmlBuffer.write("</head>");
    htmlBuffer.write("<body>");

    for (Block block in widgets) {
      /*if (widget is TextField) {
        htmlBuffer.write("<input type='text' class='text-field' value='${widget.controller?.text ?? ''}' readonly />");
      } else if (widget is Container) {
        htmlBuffer.write("<div class='container' style='background-color: ${widget.color?.toCssString() ?? 'transparent'};'>Container</div>");
      } else if (widget is Text) {
        htmlBuffer.write("<p>${widget.data}</p>");
      }
      // Add handling for other widget types if needed*/
      if (block is BoldTextBox) {
        htmlBuffer.write("<p class='text-field'> <strong> ${block
            .getValue()} </strong></p>");
      }
       else if(block is TextBox) {
        htmlBuffer.write("<style>");
        htmlBuffer.write("p text-wrap: wrap; font-weight: normal;");
        htmlBuffer.write("</style>");
        htmlBuffer.write("<p class='text-field'>${block.getValue()}</p>");
      } else if (block is FormBox) {
        htmlBuffer.write("<p>${block.getValue()}</p>");
        htmlBuffer.write('<input type="text" class="text-field" placeholder="${block.getHint()}">');
      } else if (block is TwoButtons) {
        htmlBuffer.write("<p>${block.getValue()}</p>");
        htmlBuffer.write("<input type='radio' id='${block.getA()}' name='${block.getValue()}' value='${block.getA()}'>");
        htmlBuffer.write("<label for='${block.getA()}'>${block.getA()}</label><br>");
        htmlBuffer.write("<input type='radio' id='${block.getB()}' name='${block.getValue()}' value='${block.getB()}'>");
        htmlBuffer.write("<label for='${block.getB()}'>${block.getB()}</label><br>");
      } else if (block is ThreeButtons) {
        htmlBuffer.write("<p>${block.getValue()}</p>");
        htmlBuffer.write("<input type='radio' id='${block.getA()}' name='${block.getValue()}' value='${block.getA()}'>");
        htmlBuffer.write("<label for='${block.getA()}'>${block.getA()}</label><br>");
        htmlBuffer.write("<input type='radio' id='${block.getB()}' name='${block.getValue()}' value='${block.getB()}'>");
        htmlBuffer.write("<label for='${block.getB()}'>${block.getB()}</label><br>");
        htmlBuffer.write("<input type='radio' id='${block.getC()}' name='${block.getValue()}' value='${block.getC()}'>");
        htmlBuffer.write("<label for='${block.getC()}'>${block.getC()}</label><br>");
      } else if (block is SubmitButton) {
        htmlBuffer.write("<button type='button'>Submit</button>");
      } else if (block is ImageBox) {
        final imageIndex = webImages.indexOf(block.imageData);
        final imageName = '$selectedPageName-image$imageIndex.png';
        htmlBuffer.write("<img src=../images/$imageName alt='Image $imageIndex' width='350' height=${block.getHeight()}>");
        print(imageName);
      }
    }

    htmlBuffer.write("</body>");
    htmlBuffer.write("</html>");

    return htmlBuffer.toString();
  }

   void addNewPage() {
    String htmlContent = "<html><body><h1>New Page Content</h1></body></html>";
    int highestPageNumber = 0;
    for (String name in pageNames) {
      final match = RegExp(r'page(\d+)').firstMatch(name);
      if (match != null) {
        final pageNumber = int.parse(match.group(1)!);
        if (pageNumber > highestPageNumber) {
          highestPageNumber = pageNumber;
        }
      }
    }
    final newPageName = 'page${highestPageNumber + 1}';
    uploadToServer(htmlContent, newPageName);
  }

  Future<void> uploadToServer(String htmlContent, String pageName) async {
    // Send the HTTP POST request to the Flask server
    var url = Uri.parse('http://127.0.0.1:5000/upload');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'filename': pageName, 'htmlContent': htmlContent}),
      );

      if (response.statusCode == 200) {
        print('HTML uploaded successfully');
      } else {
        print('Failed to upload HTML');
      }
    } catch (e) {
      print('Error uploading HTML: $e');
    }
  }

  Future<void> uploadImagesToServer() async {
  for (int i = 0; i < webImages.length; i++) {
    Uint8List imageBytes = webImages[i];
    String imageName = '$selectedPageName-image$i.png'; // Example filename generation

    var url = Uri.parse('http://127.0.0.1:5000/upload_image');
    var request = http.MultipartRequest('POST', url);
    request.files.add(
      http.MultipartFile.fromBytes('image', imageBytes, filename: imageName),
    );
    
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image $imageName uploaded successfully');
      } else {
        print('Failed to upload image $imageName. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image $imageName: $e');
    }
  }
}

  void onSaveButtonPressed() {
    String htmlContent = generateHTMLFromWidgets(screenElements);

    uploadImagesToServer();
    
    uploadToServer(htmlContent, selectedPageName);
  }

  void onPageNameChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedPageName = newValue;
      });
    }
  }

  File ? _selectedImage;
  Uint8List webImage = Uint8List(8);

  Future _pickImageFromGallery() async {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        var f = await image.readAsBytes();
        setState(() {
          webImages.add(f);
          localImages.add(selected);
          imageOptions.insert(0, Draggable(data: [ImageBox(f)], feedback: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.surface,
                width: 3.0
              ),
            ),
            width: 100,
            height: 100,
            child: Image.memory(f, fit: BoxFit.fill),
          ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.surface,
                  width: 3.0
                )
              ),
              width: 100,
              height: 100,
              child: Image.memory(f, fit: BoxFit.fill),
            ),
          ));
          print(imageOptions);
        });
      } else {
        print('No image has been picked');
      }
  }

  List<String> categoryNames = ['Image', 'Forms'];

  @override
  Widget build(BuildContext context) {
    if(checkV==1) {
      screenWidth = min(MediaQuery
          .of(context)
          .size
          .width * 2 / 3,
          (MediaQuery
              .of(context)
              .size
              .height * 2 / 3) / 0.5625);
      screenHeight = min(MediaQuery
          .of(context)
          .size
          .height * 2 / 3,
          (MediaQuery
              .of(context)
              .size
              .width * 2 / 3) * 0.5625);
    }
    else{
      screenWidth = min(MediaQuery
          .of(context)
          .size
          .width * 0.1975,
          (MediaQuery
              .of(context)
              .size
              .height * 9 / 16) / 0.5625);
      screenHeight = min(MediaQuery
          .of(context)
          .size
          .height * 2 / 3,
          (MediaQuery
              .of(context)
              .size
              .width * 16 / 9) * 0.5625);
    }

    int color() {
      if (colorN < 2) {
        colorN += 1;
      } else {
        colorN = 0;
      }
      return colorN;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            PopupMenuButton<String>(
              onSelected: (String result) {
                setState(() {
                  switch (result) {
                    case 'Save':
                      onSaveButtonPressed();
                      break;
                    case 'Add':
                      addNewPage();
                      break;
                    case 'Template':
                      break;
                  }
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Save',
                  child: Row(
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8),
                      Text('Save'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Add',
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add Page'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Templates',
                  child:
                  PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Forms',
                        onTap: () {
                          setState(() {
                            screenElements = [
                              FormBox(), FormBox(), SubmitButton()
                            ];
                          });
                        },
                        child: const Row(
                          children: [
                            SizedBox(width: 8),
                            Text('Forms'),
                          ],
                        ),
                      ),
                    ],
                    child: const Row(
                      children: [
                        Icon(Icons.text_snippet),
                        SizedBox(width: 8),
                        Text('Templates'),
                      ],
                    ),
                  ),
                ),
              ],
              child: const Row(
                children: [
                  const Icon(Icons.menu, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(width: 5),
            MenuAnchor(
              menuChildren: imageOptions,
                /*Draggable<Container>(
                    data: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: 3.0,
                        ),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    feedback: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: 3.0,
                        ),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    childWhenDragging: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: 3.0,
                        ),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: 3.0,
                        ),
                      ),
                      width: 100,
                      height: 100,
                      child: Center(child: Text("Image")),
                    )),*/
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return TextButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('IMAGES'));
              },
            ),
            const SizedBox(width: 5),
            MenuAnchor(
              menuChildren: <Draggable>[
                Draggable<List<Block>>(
                  data: [FormBox()],
                  feedback: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.surface,
                        width: 3.0,
                      ),
                    ),
                    width: 100,
                    height: 100,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.surface,
                        width: 3.0,
                      ),
                    ),
                    width: 100,
                    height: 100,
                    child: const Center(child: Text("Forms Box")),
                  ),
                ),
                Draggable<List<Block>>(
                  data: [TwoButtons()],
                  feedback: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                        width: 3.0,
                      ),
                    ),
                    width: 100,
                    height: 100
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                        width: 3.0,
                      )
                    ),
                    width: 100,
                    height: 100,
                    child: const Center(child: Text("2 Options")),
                  )
                ),
                Draggable<List<Block>>(
                    data: [ThreeButtons()],
                    feedback: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                            width: 3.0,
                          ),
                        ),
                        width: 100,
                        height: 100
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                            width: 3.0,
                          )
                      ),
                      width: 100,
                      height: 100,
                      child: const Center(child: Text("3 Options")),
                    )
                ),
                Draggable<List<Block>>(
                  data: [SubmitButton()],
                  feedback: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                        width: 3.0,
                      ),
                    ),
                    width: 100,
                    height: 100
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                        width: 3.0,
                      )
                    ),
                    width: 100,
                    height: 100,
                    child: const Center(child: Text("Submit Button")),
                  ),
                ),
              ],
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return TextButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('FORMS'));
              },
            ),
            const SizedBox(width: 5),
            MenuAnchor(
              menuChildren: <Draggable>[
                Draggable<List<Block>>(
                    data: [
                      TextBox()
                    ],
                    feedback: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: 3.0,
                        ),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: 3.0,
                        ),
                      ),
                      width: 100,
                      height: 100,
                      child: const Center(child: Text("Text Box")),
                    )),
                Draggable<List<Block>>(
                    data: [
                      BoldTextBox()
                    ],
                    feedback: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: 3.0,
                        ),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: 3.0,
                        ),
                      ),
                      width: 100,
                      height: 100,
                      child: const Center(child: Text("Bold Text Box")),
                    )),
              ],
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return TextButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('TEXT'));
              },
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: const Color.fromARGB(255, 151, 151, 151),
            height: 2.0,
          ),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 6,
              decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(
                        color: Color.fromARGB(255, 151, 151, 151),
                        width: 2.0,
                      ))),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: properties.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.all(8)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                properties[index],
                              ],
                            )
                          ],
                        );
                      }),
                  if (showApplyButton)
                    TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text("Apply"),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: checkV==1 ? MediaQuery.of(context).size.width/12 : MediaQuery.of(context).size.width*11/36,
                  ),
                  /*Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 6,
                    decoration: const BoxDecoration(
                        border: Border(
                            right: BorderSide(
                              color: Color.fromARGB(255, 151, 151, 151),
                              width: 2.0,
                            ))),
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: properties.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(padding: EdgeInsets.all(8)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      properties[index],
                                    ],
                                  )
                                ],
                              );
                            }),
                        if (showApplyButton)
                          TextButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text("Apply"),
                          ),
                      ],
                    ),
                  ),*/
                  DropdownButton<String>(
                    value: selectedPageName.isNotEmpty ? selectedPageName : null,
                    onChanged: onPageNameChanged,
                    items: pageNames.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 8.0)),
                  Container(
                    //width: checkV == 1 ? screenWidth : screenHeight * 9 / 16,
                    width: screenWidth,
                    height: screenHeight,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(7),
                            bottomLeft: Radius.circular(7),
                            bottomRight: Radius.circular(7)),
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 151, 151, 151),
                        )),
                    child: Listener(
                      onPointerSignal: (event) {
                        if (event is PointerScrollEvent) {
                          final offset = event.scrollDelta.dy;
                          scrollController
                              .jumpTo(scrollController.offset + offset);
                        } else if (event is PointerPanZoomEndEvent) {
                          final offset = event.delta.dy;
                          scrollController
                              .jumpTo(scrollController.offset + offset);
                        }
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: scrollController,
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.all(2)),
                            DragTarget<List<Block>>(
                              onAcceptWithDetails: (data) => setState(() {
                                globalCount++;
                                for (Block dataPack in data.data.reversed) {
                                  screenElements.insert(0, dataPack);
                                }
                                print(screenElements);
                              }),
                              builder: (context, _, __) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: screenWidth / 5,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1,
                                        color: const Color.fromARGB(
                                            255, 151, 151, 151),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Drop here',
                                    style: TextStyle(
                                      color: Colors.grey[
                                      400], // Text color to blend with the background
                                      fontStyle: FontStyle
                                          .italic, // Optional: to make it italic
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                itemCount: screenElements.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                List<Widget> ppt =
                                                screenElements[index]
                                                    .getProperties();
                                                setState(() {
                                                  properties.clear();
                                                  properties = ppt;
                                                  showApplyButton = true;
                                                });
                                              },
                                              icon: const Icon(Icons.settings)),
                                          screenElements[index].convert(screenWidth*2/3)!,
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              // Move up
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (index != 0) {
                                                        final temp =
                                                        screenElements[
                                                        index - 1];
                                                        screenElements[
                                                        index - 1] =
                                                        screenElements[index];
                                                        screenElements[index] =
                                                            temp;
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.arrow_upward)),

                                              // Move Down
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (index !=
                                                          screenElements.length -
                                                              1) {
                                                        final temp =
                                                        screenElements[
                                                        index + 1];
                                                        screenElements[
                                                        index + 1] =
                                                        screenElements[index];
                                                        screenElements[index] =
                                                            temp;
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.arrow_downward)),

                                              // Delete
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      screenElements.remove(
                                                          screenElements[index]);
                                                    });
                                                  },
                                                  icon: const Icon(Icons.delete))
                                            ],
                                          ),
                                        ],
                                      ),
                                      DragTarget<List<Block>>(
                                        onAcceptWithDetails: (data) =>
                                            setState(() {
                                              for (Block dataBlock in data.data.reversed) {
                                                screenElements.insert(index+1, dataBlock);
                                              }
                                            }),
                                        builder: (context, _, __) => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: screenWidth/5,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  width: 1,
                                                  color: const Color.fromARGB(
                                                      255, 151, 151, 151),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Drop here',
                                              style: TextStyle(
                                                color: Colors.grey[
                                                400], // Text color to blend with the background
                                                fontStyle: FontStyle
                                                    .italic, // Optional: to make it italic
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: screenHeight,
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          width: 2,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
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
                                  topRight: Radius.circular(7)),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
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
                                brightness = const Icon(Icons.mode_night_outlined,
                                    color: Colors.grey, size: 30);
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
                                  width: 2,
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
                                  bottomRight: Radius.circular(7)),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
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
                  const Padding(padding: EdgeInsets.all(8.0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
