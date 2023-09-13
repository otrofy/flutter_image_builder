import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hello/hello.dart';
import 'package:hello/hello_method_channel.dart';
import 'package:hello/hello_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHelloPlatform
    with MockPlatformInterfaceMixin
    implements HelloPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

@GenerateMocks([FlutterImageCompress])
void main() async {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  final HelloPlatform initialPlatform = HelloPlatform.instance;

  test('$MethodChannelHello is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHello>());
  });

  test('getPlatformVersion', () async {
    Hello helloPlugin = Hello();

    MockHelloPlatform fakePlatform = MockHelloPlatform();
    HelloPlatform.instance = fakePlatform;

    expect(await helloPlugin.getPlatformVersion(), '42');
  });

  test('convertfile', () async {
    when(await FlutterImageCompress.compressAndGetFile(
      'images/1.webp',
      'images/1.jpg',
      quality: 10,
    ))
        .thenAnswer((realInvocation) => XFile('images/1.png'));
    when(await getExternalStorageDirectory())
        .thenAnswer((realInvocation) => (Directory('files')));

    var result = await Hello.convertFileToOtherFormat(
        file: XFile('images/1.webp'), finalFormat: 'jpg', quality: 10);
    expect(result!.path, 'images/1.png');
  });
}
