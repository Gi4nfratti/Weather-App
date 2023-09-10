import 'dart:convert';
import 'package:weather/auth/keysSecret.dart' as keysSecret;
import 'package:http/http.dart' as http;
import 'package:weather/models/forecast_day.dart';
import '../models/forecast_hour.dart';

class NextDaysPageController {
  Future<List<ForecastDay>> getNextDaysForecast(String country) async {
    List<ForecastDay> forecastNextDays = [];
    await http
        .get(Uri.parse(
            'https://api.weatherapi.com/v1/forecast.json?key=${keysSecret.key}&q=${country}&days=3&aqi=no&alerts=no'))
        .then((response) {
      var json = jsonDecode(response.body);
      var forecastList = json['forecast']['forecastday'];
      for (var forecast in forecastList) {
        forecastNextDays.add(
          ForecastDay(
            date: forecast['date'],
            avgTemp: forecast['day']['avgtemp_c'],
            avghumidity: forecast['day']['avghumidity'],
            maxTemp: forecast['day']['maxtemp_c'],
            minTemp: forecast['day']['mintemp_c'],
            totalPrecip: forecast['day']['totalprecip_mm'],
            forecastHour: _setForecastHourList(forecast),
          ),
        );
      }
    });

    return forecastNextDays;
  }

  List<ForecastHour> _setForecastHourList(dynamic forecastDay) {
    List<ForecastHour> forecastHour = [];

    for (var hour in forecastDay['hour']) {
      forecastHour.add(ForecastHour(
          time: hour['time'],
          iconURL: hour['condition']['icon'],
          avgTemp: hour['temp_c'].toString()));
    }
    return forecastHour;
  }
}
