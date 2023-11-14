import 'package:flutter_test/flutter_test.dart';
import 'package:jail_guard/jail_guard.dart';
import 'package:jail_guard/jail_guard_platform_interface.dart';
import 'package:jail_guard/jail_guard_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJailGuardPlatform
    with MockPlatformInterfaceMixin
    implements JailGuardPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final JailGuardPlatform initialPlatform = JailGuardPlatform.instance;

  test('$MethodChannelJailGuard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelJailGuard>());
  });

  test('getPlatformVersion', () async {
    JailGuard jailGuardPlugin = JailGuard();
    MockJailGuardPlatform fakePlatform = MockJailGuardPlatform();
    JailGuardPlatform.instance = fakePlatform;

    expect(await jailGuardPlugin.getPlatformVersion(), '42');
  });
}
