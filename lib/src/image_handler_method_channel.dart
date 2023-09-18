import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'image_handler_platform_interface.dart';

/// /// An implementation of [ImageHandlerPlatform] that interacts with the native platform
/// through method channels to get platform-specific details.

class MethodChannelImageHandler extends ImageHandlerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('image_handler');

  /// Retrieves the platform version from the native side.
  @override
  Future<String?> getPlatformVersion() async {
    try {
      return await methodChannel.invokeMethod<String>('getPlatformVersion');
    } catch (error) {
      // Handle or log the error as per the requirement.
      debugPrint("Failed to get platform version: $error");
      return null;
    }
  }
}
