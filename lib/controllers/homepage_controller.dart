import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/forecast_hour.dart';
import 'package:weather/auth/keysSecret.dart' as keysSecret;

class HomePageController {
  static const STANDARD_CITY = 'London';

  Future<String?> GetCountryByLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      var addr = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      return addr[0].administrativeArea;
    } on Exception {
      print('EXCEPTION!!!');
      return STANDARD_CITY;
    }
  }

  Future<(List<ForecastHour>, String, int)> getTodaysWeather(
      String country) async {
    String avgTemp = "";
    int focusedHourForecast = 0;
    final List<ForecastHour> forecastHour = [];
    await http
        .get(Uri.parse(
            'http://api.weatherapi.com/v1/forecast.json?key=${keysSecret.key}&q=${country}&days=1&aqi=no&alerts=no'))
        .then((response) {
      var json = jsonDecode(response.body);
      for (var hour in json['forecast']['forecastday'][0]['hour']) {
        forecastHour.add(ForecastHour(
            avgTemp: '${hour['temp_c']}ºC',
            time: (hour['time'] as String).substring(11),
            iconURL: hour['condition']['icon']));
      }
      avgTemp = '${json['current']['temp_c']}ºC';
      var lastUpdated =
          (json['current']['last_updated'] as String).substring(11, 13);
      focusedHourForecast =
          forecastHour.indexWhere((e) => e.time.substring(0, 2) == lastUpdated);
    });
    return (forecastHour, avgTemp, focusedHourForecast);
  }
}
