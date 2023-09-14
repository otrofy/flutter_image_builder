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

class ImageHandler {
  Future<String?> getPlatformVersion() {
    return ImageHandlerPlatform.instance.getPlatformVersion();
  }

  static Future<void> checkCompressedFileSize(XFile? file) async {
    if (file == null) {
      return;
    }

    final compressedPath = file.path;
    final compressedFile = File(compressedPath);

    if (await compressedFile.exists()) {
      final compressedFileSize = await compressedFile.length();
      debugPrint('Compressed file size: $compressedFileSize bytes');
    }
  }

  static Future<XFile?> assetToXFile(String assetPath) async {
    // Load the asset as bytes
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    final format = assetPath.split('.').last;

    // Create a temporary directory to store the file
    final tempDir = await getTemporaryDirectory();
    final tempFilePath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.$format';

    // Write the bytes to a temporary file
    await File(tempFilePath).writeAsBytes(bytes);

    final downloadsDirectory = await getExternalStorageDirectory();

    final destinationPath = '${downloadsDirectory!.path}/output123.$format';

    // Write the bytes to a file in the downloads directory
    final destinationFile = File(destinationPath);
    await destinationFile.writeAsBytes(bytes);

    // Convert the temporary file path to an XFile
    return XFile(destinationPath);
  }

  static Future<XFile?> convertFileToOtherFormat(
      {XFile? file, String? finalFormat, int? quality}) async {
    file ??= await assetToXFile('assets/images/1.webp');

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

    finalFormat ??= "jpg";

    // Create a temporary output file path with a ".jpg" extension
    final lastIndex = filePath.lastIndexOf('.');
    final splitted = filePath.substring(0, lastIndex);
    final outPath = '${splitted}_out.$finalFormat';

    // Compress and get the result as a File
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: quality ?? 88,
      format: finalFormat == "png"
          ? CompressFormat.png
          : finalFormat == "webp"
              ? CompressFormat.webp
              : CompressFormat.jpeg,
    );

    return XFile(result!.path);
  }

  static Future<CroppedFile> cropImage(
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
    return croppedFile!;
  }

  static Future selectFile({required FileType type}) async {
    try {
      FilePickerResult? image =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (image != null) {
        return image;
      } else {
        return;
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint("Error al seleccionar archivo: $e");
      }
    }
  }

  static Future pickImageCamera({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      return image;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint("Error al seleccionar archivo: $e");
      }
    }
  }
}
