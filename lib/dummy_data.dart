import 'package:intl/intl.dart';
import 'package:weather/models/condition.dart';
import 'package:weather/models/forecast_hour.dart';

import 'models/forecast_day.dart';

List<ForecastDay> forecastDayListTest = [
  ForecastDay(
    forecastHour: forecastHourListTest,
    avgTemp: 20.0,
    avghumidity: 80,
    date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    maxTemp: 26.0,
    minTemp: 15.0,
    totalPrecip: 30
  ),  
  ForecastDay(
    forecastHour: forecastHourListTest,
    avgTemp: 30.0,
    avghumidity:780,
    date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    maxTemp: 36.0,
    minTemp: 25.0,
    totalPrecip: 20
  ),  
  ForecastDay(
    forecastHour: forecastHourListTest,
    avgTemp: 30.0,
    avghumidity: 50,
    date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    maxTemp: 46.0,
    minTemp: 18.0,
    totalPrecip: 1
  ),
];

List<ForecastHour> forecastHourListTest = [
  ForecastHour(
    condition: Condition(
      code: 999,
      iconUrl: "testeIconUrl",
      text: "condition1"
    ),
    avgTemp: 20,
    wind: 45
  ),
  ForecastHour(
    condition: Condition(
      code: 998,
      iconUrl: "testeIconUrl",
      text: "condition1"
    ),
    avgTemp: 30,
    wind: 5
  ),
];

const onboardingTexts = [
  'Veja as previsões e detalhes do tempo na sua cidade e de outras pelo mundo afora',
  'Tenha acesso ao clima e outras informações sobre os próximos dias',
  'Bem-vindo ao Weather, onde lhe entregamos o melhor da metereologia!',
];


