import 'package:mesapp/Config/developer_config.dart';
import 'package:mesapp/Config/production_config.dart';
import 'package:mesapp/Config/testing_config.dart';

class AppConfig {
  static late String baseUrl;
  static late String mesUrl;
  static late String appConfig;

  static void loadConfig() {
    const flavor = String.fromEnvironment('FLAVOR');
    if (flavor == 'Developer') {
      baseUrl = DeveloperConfig.baseUrl;
      mesUrl = DeveloperConfig.mesUrl;
      appConfig = 'Developer';
    }
    if(flavor == 'Testing') {
      baseUrl = TestingConfig.baseUrl;
      mesUrl = TestingConfig.mesUrl;
      appConfig = 'Testing';
    }
    if(flavor == 'Production') {
      baseUrl = ProductionConfig.baseUrl;
      mesUrl = ProductionConfig.mesUrl;
      appConfig = 'Production';
    }
  }
}
