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
  final ImageHandlerPlatform initialPlatform = ImageHandlerPlatform.instance;

  test('$MethodChannelImageHandler is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelImageHandler>());
  });

  test('getPlatformVersion', () async {
    ImageHandler imageHandlerPlugin = ImageHandler();
    MockImageHandlerPlatform fakePlatform = MockImageHandlerPlatform();
    ImageHandlerPlatform.instance = fakePlatform;

    expect(await imageHandlerPlugin.getPlatformVersion(), '42');
  });
}
