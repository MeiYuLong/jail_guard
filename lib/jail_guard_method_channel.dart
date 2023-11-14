import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'jail_guard_platform_interface.dart';

/// An implementation of [JailGuardPlatform] that uses method channels.
class MethodChannelJailGuard extends JailGuardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('jail_guard');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> checkJailbreak() async {
    final jailbreak = await methodChannel.invokeMethod<bool>('checkJailbreak');
    print(jailbreak.toString());
    return jailbreak ?? false;
  }
}
