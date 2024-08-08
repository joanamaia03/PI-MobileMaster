//import 'dart:html';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/web_view_container.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const WebviewExample(),
        '/webViewContainer': (context) => const WebViewContainer()
      },
    ));

class WebviewExample extends StatefulWidget {
  const WebviewExample({super.key});

  @override
  State<WebviewExample> createState() => _WebviewExampleState();
}

class _WebviewExampleState extends State<WebviewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/logo.png"),
              fit: BoxFit.contain,
            ),
          ),
        ),
        leadingWidth: 100,
        elevation: 0,
        actions: [
          const Icon(
            size: 40,
            Icons.cloud_outlined,
            color: Colors.black,
          ),
          const SizedBox(
            width: 6,
          ),
          const Column(
            children: [
              Expanded(child: Text("")),
              Text(
                "09:55",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "14°C",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Expanded(child: Text("")),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 40,
              child: Icon(
                size: 30,
                Icons.message_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: content(),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bem-vindo",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.sizeOf(context).height / 5,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/image1.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const Text(
            "Sobre nós",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: Icon(
                        size: 30,
                        Icons.apartment_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Text(
                    "SOBRE NÓS",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: Icon(
                        size: 30,
                        Icons.phone_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Text(
                    "CONTACTOS",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Áreas",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CarouselSlider(
            items: ["Bolsas de Estudo", "Alojamento", "Alimentação"].map(
              (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: MediaQuery.sizeOf(context).height / 7,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            image: DecorationImage(
                              image: AssetImage("assets/image $i.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/webViewContainer');
                        },
                      ),
                      Text(
                        i,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                );
              },
            ).toList(),
            options: CarouselOptions(
              height: MediaQuery.sizeOf(context).height/7+23,
              viewportFraction: 0.4,
              pageSnapping: false,
              disableCenter: true,
              enableInfiniteScroll: false,
              padEnds: false,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Sugestões para Ti",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height / 7,
                    width: MediaQuery.sizeOf(context).width / 2 - 15,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      image: DecorationImage(
                        image: AssetImage("assets/image2.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const Text(
                    "Pontos de interesse",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height / 7,
                    width: MediaQuery.sizeOf(context).width/2-15,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      image: DecorationImage(
                        image: AssetImage("assets/image3.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const Text(
                    "Planeia a tua viagem",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
