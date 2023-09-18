import 'package:flutter_test/flutter_test.dart';
import 'package:image_handler/image_handler_platform_interface.dart';
import 'package:image_handler/image_handler_method_channel.dart';
import 'package:image_handler/src/image_handler.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockImageHandlerPlatform
    with MockPlatformInterfaceMixin
    implements ImageHandlerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  // Store the original platform instance to restore after tests
  final ImageHandlerPlatform initialPlatform = ImageHandlerPlatform.instance;
  setUp(() {
    // Reset to the initial platform before each test
    ImageHandlerPlatform.instance = initialPlatform;
  });
  group('ImageHandlerPlatform Tests', () {
    test('$MethodChannelImageHandler is the default instance', () {
      expect(ImageHandlerPlatform.instance,
          isInstanceOf<MethodChannelImageHandler>());
    });
    test('getPlatformVersion returns mocked value', () async {
      ImageHandler imageHandlerPlugin = ImageHandler();
      MockImageHandlerPlatform fakePlatform = MockImageHandlerPlatform();
      // Set the instance to our fake platform
      ImageHandlerPlatform.instance = fakePlatform;
      expect(await imageHandlerPlugin.getPlatformVersion(), '42');
    });
  });
}
