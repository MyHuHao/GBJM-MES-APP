import 'package:mesapp/Config/staging_config.dart';
import 'package:mesapp/Config/dev_config.dart';

class AppConfig {
  static late String baseUrl;
  static late String mesUrl;
  static late String appConfig;

  static void loadConfig() {
    const flavor = String.fromEnvironment('FLAVOR');
    if (flavor == 'dev') {
      baseUrl = DevConfig.baseUrl;
      mesUrl = DevConfig.mesUrl;
      appConfig = 'dev';
    } else if (flavor == 'staging') {
      baseUrl = StagingConfig.baseUrl;
      mesUrl = StagingConfig.mesUrl;
      appConfig = 'staging';
    } else {
      throw Exception('FLAVOR not found!');
    }
  }
}
