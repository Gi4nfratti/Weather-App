import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:weather/controllers/countrieslistpage_controller.dart';
import 'package:weather/controllers/homepage_controller.dart';
import 'package:weather/controllers/nextdayspage_controller.dart';
import 'package:country_state_city/country_state_city.dart' as statesP;
import '../models/country.dart';
import '../models/forecast_day.dart';
import '../models/forecast_hour.dart';

part 'forecast_store.g.dart';

class ForecastStore = _ForecastStore with _$ForecastStore;

abstract class _ForecastStore with Store {
  HomePageController homeController = HomePageController();
  NextDaysPageController nextController = NextDaysPageController();
  CountriesListPageController countriesController =
      CountriesListPageController();

  @observable
  String country = "";

  @observable
  String avgTemp = "";

  @observable
  int focusedHourForecast = 0;

  @observable
  List<ForecastHour> forecastHour = [];

  @observable
  List<ForecastDay> forecastNextDays = [];

  @observable
  List<Country> countriesList = [];

  @observable
  ObservableList<String> statesList = ObservableList();

  @action
  Future<void> UpdateLocation() async {
    if (country.isEmpty)
      await homeController.GetCountryByLocation()
          .then((value) => country = value!);
  }

  @action
  Future<void> UpdateForecast() async {
    await homeController.getTodaysWeather(country).then((value) {
      forecastHour = value.$1;
      avgTemp = value.$2;
      focusedHourForecast = value.$3;
    });
  }

  @action
  Future<void> UpdateNextDays() async {
    forecastNextDays = await nextController.getNextDaysForecast(country);
  }

  @action
  Future<void> UpdateCountries() async {
    countriesList = await countriesController.retrieveCountriesList();
  }

  @action
  Future<void> RetrieveStates(String country) async {
    statesList.clear();
    await statesP.getStatesOfCountry(country).then((value) {
      value.forEach((state) => statesList.add(state.name));
    });
  }
}
