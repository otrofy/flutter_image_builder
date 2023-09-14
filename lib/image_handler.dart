import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'image_handler_platform_interface.dart';
export 'package:flutter_image_compress/flutter_image_compress.dart'; // Exporta la biblioteca aquí
export 'package:image_cropper/image_cropper.dart'; // Exporta la biblioteca aquí
export 'package:image_picker/image_picker.dart';
export 'package:file_picker/file_picker.dart';

class ImageHandler {
  Future<String?> getPlatformVersion() {
    return ImageHandlerPlatform.instance.getPlatformVersion();
  }

  /// This function check the image size this receive a [XFile] as an input and return the size of the file as an [int]
  static Future<int> checkCompressedFileSize(XFile? file) async {
    if (file == null) {
      return 0;
    }

    final compressedPath = file.path;
    final compressedFile = File(compressedPath);

    if (await compressedFile.exists()) {
      final compressedFileSize = await compressedFile.length();
      debugPrint('Compressed file size: $compressedFileSize bytes');
      return compressedFileSize;
    }
    return 0;
  }

  /// This function convert an asset file receiving a [String] of the path and returning a [XFile] except the format file [jpg]
  static Future<XFile?> convertFileToOtherFormat(
      {required XFile? file,
      String finalFormat = 'jpeg',
      required int quality}) async {
    //checkCompressedFileSize(file);
    final filePath = file!.path;
    final validExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.heic',
      '.heif'
    ];

    // Check if the file extension is supported
    final extension = filePath.substring(filePath.lastIndexOf('.'));
    if (!validExtensions.contains(extension.toLowerCase())) {
      throw Exception("Unsupported file format");
    }

    // Create a temporary output file path with a ".jpg" extension
    final lastIndex = filePath.lastIndexOf('.');
    final splitted = filePath.substring(0, lastIndex);
    final outPath = '${splitted}_out.$finalFormat';

    // Compress and get the result as a File
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: quality,
      format: finalFormat == "png"
          ? CompressFormat.png
          : finalFormat == "webp"
              ? CompressFormat.webp
              : CompressFormat.jpeg,
    );

    return XFile(result!.path);
  }

  static Future<XFile> cropImage(
      {required var pickedFile,
      var context,
      required String title,
      required int quality}) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: quality,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: title,
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: title,
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort:
              const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    XFile file = XFile(croppedFile!.path);
    return file;
  }

  static Future selectFile({required FileType type}) async {
    try {
      FilePickerResult? image = await FilePicker.platform.pickFiles(type: type);
      if (type == FileType.video) {
        if (image != null) {
          final imageTemporary = XFile(image.files.single.path!);
          File file1 = File(imageTemporary.path);
          return file1;
        } else {
          return;
        }
      } else if (type == FileType.image) {
        if (image != null) {
          final imageTemporary = XFile(image.files.single.path!);
          return imageTemporary;
        } else {
          return;
        }
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint("Error al seleccionar archivo: $e");
      }
    }
  }

  static Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      return image;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint("Error al seleccionar archivo: $e");
      }
    }
  }
}
