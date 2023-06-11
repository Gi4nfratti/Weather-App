import 'condition.dart';

class ForecastHour {
  final Condition condition;
  final double avgTemp;
  final double wind;

  ForecastHour({required this.condition, this.avgTemp = 0, this.wind = 0});
}
