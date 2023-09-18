import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'image_handler_platform_interface.dart';

/// A class that provides utilities for handling images in a Flutter application.

class ImageHandler {
  /// Gets the current platform version.
  ///
  /// Returns a `String` with the current platform version or `null` if it couldn't be retrieved.

  Future<String?> getPlatformVersion() {
    return ImageHandlerPlatform.instance.getPlatformVersion();
  }

  /// Checks the size of a compressed file.
  ///
  /// Receives an [XFile] as input and returns the size of the file as an [int] in bytes.
  /// If the file is null, it returns 0.
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

  /// Converts a file to another format.
  ///
  /// Receives an [XFile] as input, a final format (default is 'jpeg'), and a quality.
  /// Returns an [XFile] with the converted file or `null` if an error occurs.
  static Future<XFile?> convertFileToOtherFormat(
      {required XFile? file,
      String finalFormat = 'jpeg',
      required int quality}) async {
    // ... (check and get the size of the file)
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

  /// Crops an image.
  ///
  /// Receives an image file, the application context, a title, and a quality.
  /// Returns an [XFile] with the cropped image or `null` if the operation is canceled.

  static Future<XFile> cropImage(
      {required var pickedFile,
      var context,
      required String title,
      required int quality,
      int widthCroppieBoundary = 520,
      int heightCroppieBoundary = 520,
      int widthCroppieViewPort = 480,
      int heightCroppieViewPort = 480}) async {
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
          boundary: CroppieBoundary(
            width: widthCroppieBoundary,
            height: heightCroppieBoundary,
          ),
          viewPort: CroppieViewPort(
              width: widthCroppieViewPort,
              height: heightCroppieViewPort,
              type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    XFile file = XFile(croppedFile!.path);
    return file;
  }

  /// Crops an image.
  ///
  /// Receives an image file, the application context, a title, and a quality.
  /// Returns an [XFile] with the cropped image or `null` if the operation is canceled.
  /// Returns an [File] if the user select as a input parameter [FileType.video]

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
        debugPrint("There was an error picking the file: $e");
      }
    }
  }

  /// Picks an image from the camera.
  ///
  /// Returns an [XFile] with the picked image or `null` if an error occurs.

  static Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      return image;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint("There was an error picking the file: $e");
      }
    }
  }
}
