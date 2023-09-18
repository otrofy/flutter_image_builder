import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'image_handler_platform_interface.dart';

/// An implementation of [ImageHandlerPlatform] that uses method channels.
class MethodChannelImageHandler extends ImageHandlerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('image_handler');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
