import 'package:flutter/widgets.dart';
import 'package:mesapp/Model/Home/home_model.dart';
import 'package:mesapp/Service/Http/api_service.dart';

class HomeService with ChangeNotifier {
  // 天气
  Future<WeatherData> getWeatherData() async {
    WeatherData result = WeatherData();
    try {
      final response = await DioHelper.get(
          "https://restapi.amap.com", '/v3/weather/weatherInfo?city=441900&key=9f9046ed1ebdaa94a8fef2142f6616a6&extensions=base&output=JSON',
          requiresToken: false);
      if (response.statusCode == 200) {
        final res = response.data;
        if (res['status'] == "1") {
          result = WeatherData.fromJson(res['lives'][0]);
        }
        return result;
      }
      return result;
    } catch (e) {
      return result;
    }
  }
}
