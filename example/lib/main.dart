import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_handler/image_handler.dart';
import 'package:image_handler_example/permissions.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _imageHandlerPlugin = ImageHandler();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    requestPermissions();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _imageHandlerPlugin.getPlatformVersion() ??
          'Unknown platform version';
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

  @override
  Widget build(BuildContext context) {
    var image;
    bool hayImagen = false;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder(
            future: ImageHandler.convertFileToOtherFormat(
                finalFormat: 'webp', quality: 20),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Image.file(File(snapshot.data!.path)),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            image = ImageHandler.cropImage(
                                pickedFile: File(snapshot.data!.path),
                                context: context,
                                quality: 50,
                                title: 'Image Cropper');
                            hayImagen = true;
                          });
                        },
                        backgroundColor: const Color(0xFFBC764A),
                        tooltip: 'Crop',
                        child: const Icon(Icons.crop),
                      ),
                    ),
                    hayImagen
                        ? Image.file(File(image!.path))
                        : const SizedBox(),
                    FloatingActionButton(
                      onPressed: () async {
                        XFile file = await ImageHandler.pickImageCamera(
                            source: ImageSource.gallery);
                      },
                      child: const Icon(Icons.camera),
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        XFile file =
                            await ImageHandler.selectFile(type: FileType.image);
                      },
                      child: const Icon(Icons.camera),
                    )
                  ],
                );
              } else {
                return const Text('No data');
              }
            }),
      ),
    );
  }
}
