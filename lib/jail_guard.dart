
import 'jail_guard_platform_interface.dart';

class JailGuard {
  Future<String?> getPlatformVersion() {
    return JailGuardPlatform.instance.getPlatformVersion();
  }

  Future<bool> checkJailbreak() {
    return JailGuardPlatform.instance.checkJailbreak();
  }
}
