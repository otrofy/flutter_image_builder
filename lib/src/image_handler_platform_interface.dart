import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'image_handler_method_channel.dart';

/// Represents a platform interface for image handling.
/// All platform-specific implementations should extend this class.
abstract class ImageHandlerPlatform extends PlatformInterface {
  /// Constructs a ImageHandlerPlatform.
  ImageHandlerPlatform() : super(token: _token);

  static final Object _token = Object();
  // Holds the instance of the platform-specific implementation.

  static ImageHandlerPlatform _instance = MethodChannelImageHandler();

  /// The default instance of [ImageHandlerPlatform] to use.
  /// Defaults to [MethodChannelImageHandler].

  static ImageHandlerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ImageHandlerPlatform] when
  /// they register themselves.
  static set instance(ImageHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
