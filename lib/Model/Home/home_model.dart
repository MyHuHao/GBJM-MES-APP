class WeatherData {
  String province;
  String city;
  String adcode;
  String weather;
  String temperature;
  String winddirection;
  String windpower;
  String humidity;
  String reporttime;

  // 添加构造函数
  WeatherData({
    this.province = '',
    this.city = '',
    this.adcode = '',
    this.weather = '',
    this.temperature = '',
    this.winddirection = '',
    this.windpower = '',
    this.humidity = '',
    this.reporttime = '',
  });

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'city': city,
      'adcode': adcode,
      'weather': weather,
      'temperature': temperature,
      'winddirection': winddirection,
      'windpower': windpower,
      'humidity': humidity,
      'reporttime': reporttime,
    };
  }

  // 添加 fromJson 方法
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      province: json['province'],
      city: json['city'],
      adcode: json['adcode'],
      weather: json['weather'],
      temperature: json['temperature'],
      winddirection: json['winddirection'],
      windpower: json['windpower'],
      humidity: json['humidity'],
      reporttime: json['reporttime'],
    );
  }
}
