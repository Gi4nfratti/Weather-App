import 'forecast_hour.dart';

class ForecastDay {
  final double minTemp;
  final double maxTemp;
  final double avgTemp;
  final double totalPrecip;
  final double avghumidity;
  final String date;
  final List<ForecastHour> forecastHour;

  ForecastDay({this.minTemp = 0, this.maxTemp = 0, this.avgTemp = 0, this.totalPrecip = 0,
      this.avghumidity = 0, this.date = "", required this.forecastHour});
}
