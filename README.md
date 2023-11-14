# jail_guard

A flutter plugin package to detect device security

## Getting Started

a specialized package that includes platform-specific implementation code for
Android and/or iOS.
-Implementing iOS jailbroken device detection.
-Implement android root device detection.

```dart
import 'package:jail_guard/jail_guard.dart';
    
final _jailGuardPlugin = JailGuard();
var jailbreak = await _jailGuardPlugin.checkJailbreak();
```