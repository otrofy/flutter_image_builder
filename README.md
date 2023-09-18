# Flutter Image Handler Plugin

The Flutter Image Handler plugin provides utilities for handling images in a Flutter application. It includes features for image compression, format conversion, cropping, and selecting images from various sources.

## Features

### 1. Check Compressed File Size

- `static Future<int> checkCompressedFileSize(XFile? file)`: Checks the size of a compressed file specified by an `XFile` and returns the size in bytes. Returns 0 if the file is null.

### 2. Convert File to Other Format

- `static Future<XFile?> convertFileToOtherFormat({required XFile? file, String finalFormat = 'jpeg', required int quality})`: Converts a file to another format with the specified quality. Supported formats include JPEG, PNG, GIF, BMP, WebP, HEIC, and HEIF.

### 3. Crop Image

- `static Future<XFile> cropImage({required var pickedFile, var context, required String title, required int quality, int widthCroppieBoundary = 520, int heightCroppieBoundary = 520, int widthCroppieViewPort = 480, int heightCroppieViewPort = 480})`: Crops an image with customizable settings such as title, quality, and crop boundaries. Supports Android, iOS, and web platforms.

### 4. Select File

- `static Future selectFile({required FileType type})`: Allows users to select files or videos from their device. Returns an `XFile` for image files and a `File` for video files.

### 5. Pick Image from Camera

- `static Future pickImageCamera()`: Captures an image from the device's camera and returns an `XFile` with the picked image.

## Usage

Here's how you can use the Flutter Image Handler plugin in your Flutter application:

1. Import the plugin:
   ```dart
   import 'package:flutter_image_handler/flutter_image_handler.dart';
   ```

2. Initialize the `ImageHandler` instance:
   ```dart
   final imageHandler = ImageHandler();
   ```

3. Use the available methods to perform image-related tasks.

## Example

```dart
// Check the size of a compressed file
int fileSize = await ImageHandler.checkCompressedFileSize(someXFile);
print('Compressed file size: $fileSize bytes');

// Convert a file to another format
XFile? convertedFile = await ImageHandler.convertFileToOtherFormat(
  file: someXFile,
  finalFormat: 'png',
  quality: 80,
);
print('Converted file path: ${convertedFile?.path}');

// Crop an image
XFile croppedImage = await ImageHandler.cropImage(
  pickedFile: someXFile,
  context: context,
  title: 'Crop Image',
  quality: 90,
);
print('Cropped image path: ${croppedImage.path}');

// Select a file (image or video)
var selectedFile = await ImageHandler.selectFile(type: FileType.image);
if (selectedFile is XFile) {
  print('Selected image path: ${selectedFile.path}');
} else if (selectedFile is File) {
  print('Selected video path: ${selectedFile.path}');
}

// Pick an image from the camera
XFile? pickedImage = await ImageHandler.pickImageCamera();
print('Picked image path: ${pickedImage?.path}');
```

Please make sure to handle exceptions and error scenarios as needed in your application.

## License

This Flutter plugin is open-source and licensed under the MIT License. You can find the source code and license details in the [GitHub repository](https://github.com/your-repo-link).

## Issues and Contributions

If you encounter any issues or have suggestions for improvements, please open an issue on the GitHub repository. Contributions and pull requests are welcome!

---

**Note**: Replace `your-repo-link` with the actual GitHub repository link for the Flutter Image Handler plugin.