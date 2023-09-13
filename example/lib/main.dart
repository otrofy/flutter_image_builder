import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hello/hello.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  var status = await Permission.manageExternalStorage.status;

  if (!status.isGranted) {
    await Permission.manageExternalStorage.request();
  }
}

// Future<void> requestPermissions2() async {
//   var status = await Permission.phone.status;

//   if (!status.isGranted) {
//     await Permission.photos.request();
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _helloPlugin = Hello();

  @override
  void initState() {
    super.initState();
    requestPermissions();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _helloPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // Future<XFile?> _loadAndConvertImage() async {
  //   // Load the asset and get the XFile
  //   final assetFile = await _helloPlugin.assetToXFile('images/1.png');

  //   if (assetFile == null) {
  //     return null; // Handle the case where assetToXFile fails
  //   }

  //   // Convert the XFile to another format
  //   return Hello()
  //       .convertFileToOtherFormat(file: assetFile, finalFormat: 'png',);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder(
            future: Hello.convertFileToOtherFormat(
                finalFormat: 'webp', quality: 20),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.file(File(snapshot.data!.path));
              } else {
                return const Text('No data');
              }
            }),
      ),
    );
  }
}
