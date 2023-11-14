import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jail_guard_method_channel.dart';

abstract class JailGuardPlatform extends PlatformInterface {
  /// Constructs a JailGuardPlatform.
  JailGuardPlatform() : super(token: _token);

  static final Object _token = Object();

  static JailGuardPlatform _instance = MethodChannelJailGuard();

  /// The default instance of [JailGuardPlatform] to use.
  ///
  /// Defaults to [MethodChannelJailGuard].
  static JailGuardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JailGuardPlatform] when
  /// they register themselves.
  static set instance(JailGuardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> checkJailbreak() {
    throw UnimplementedError('checkJailbreak() has not been implemented.');
  }
}
