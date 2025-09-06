
import 'flutter_core_platform_interface.dart';

class FlutterCore {
  Future<String?> getPlatformVersion() {
    return FlutterCorePlatform.instance.getPlatformVersion();
  }
}
