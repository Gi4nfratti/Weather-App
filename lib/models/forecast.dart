import 'forecast_day.dart';

class Forecast {
  final String city;
  final String country;
  final String localtime;
  final List<ForecastDay> forecastDay;

  Forecast({
    this.city = "",
    this.country = "",
    this.localtime = "",
    required this.forecastDay,
  });
}
