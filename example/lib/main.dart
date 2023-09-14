import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_handler/image_handler.dart';
import 'package:image_handler_example/permissions.dart';
import 'package:video_player/video_player.dart';

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

  XFile? image;
  dynamic? file;
  bool hayImagen = false;
  bool hayImagen1 = false;
  VideoPlayerController? _videoPlayerController;

  loadVideoPlayer(File file) {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }

    _videoPlayerController = VideoPlayerController.file(file);
    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    // image = await ImageHandler.cropImage(
                    //     pickedFile: File(file),
                    //     context: context,
                    //     quality: 50,
                    //     title: 'Image Cropper');

                    setState(() {
                      hayImagen = true;
                    });
                  },
                  backgroundColor: const Color(0xFFBC764A),
                  tooltip: 'Crop',
                  child: const Icon(Icons.crop),
                ),
              ),
              hayImagen
                  ? Container(
                      height: 50,
                      width: 100,
                      child: Image.file(
                        File(image!.path),
                        width: 100,
                        height: 50,
                      ))
                  : const SizedBox(),
              FloatingActionButton(
                onPressed: () async {
                  file = await ImageHandler.pickImageCamera();
                  hayImagen1 = true;
                  setState(() {});
                },
                child: const Icon(Icons.camera),
              ),
              FloatingActionButton(
                onPressed: () async {
                  file = await ImageHandler.selectFile(type: FileType.video);

                  loadVideoPlayer(file);

                  hayImagen1 = true;
                  setState(() {});
                },
                child: const Icon(Icons.camera),
              ),
              // hayImagen1 ? Image.file(File(file!.path)) : SizedBox(),
              FloatingActionButton(
                onPressed: () async {},
                child: const Icon(Icons.camera),
              ),
              Center(
                child: Stack(
                  children: [
                    if (_videoPlayerController != null) ...[
                      Container(
                        height: 350,
                        width: 350,
                        child: AspectRatio(
                          aspectRatio:
                              _videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController!),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _videoPlayerController!.play();
                  });
                },
                child: Icon(Icons.pause),
              ),
            ],
          )),
    );
  }
}
