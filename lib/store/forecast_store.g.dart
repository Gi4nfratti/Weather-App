// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ForecastStore on _ForecastStore, Store {
  late final _$countryAtom =
      Atom(name: '_ForecastStore.country', context: context);

  @override
  String get country {
    _$countryAtom.reportRead();
    return super.country;
  }

  @override
  set country(String value) {
    _$countryAtom.reportWrite(value, super.country, () {
      super.country = value;
    });
  }

  late final _$avgTempAtom =
      Atom(name: '_ForecastStore.avgTemp', context: context);

  @override
  String get avgTemp {
    _$avgTempAtom.reportRead();
    return super.avgTemp;
  }

  @override
  set avgTemp(String value) {
    _$avgTempAtom.reportWrite(value, super.avgTemp, () {
      super.avgTemp = value;
    });
  }

  late final _$focusedHourForecastAtom =
      Atom(name: '_ForecastStore.focusedHourForecast', context: context);

  @override
  int get focusedHourForecast {
    _$focusedHourForecastAtom.reportRead();
    return super.focusedHourForecast;
  }

  @override
  set focusedHourForecast(int value) {
    _$focusedHourForecastAtom.reportWrite(value, super.focusedHourForecast, () {
      super.focusedHourForecast = value;
    });
  }

  late final _$forecastHourAtom =
      Atom(name: '_ForecastStore.forecastHour', context: context);

  @override
  List<ForecastHour> get forecastHour {
    _$forecastHourAtom.reportRead();
    return super.forecastHour;
  }

  @override
  set forecastHour(List<ForecastHour> value) {
    _$forecastHourAtom.reportWrite(value, super.forecastHour, () {
      super.forecastHour = value;
    });
  }

  late final _$forecastNextDaysAtom =
      Atom(name: '_ForecastStore.forecastNextDays', context: context);

  @override
  List<ForecastDay> get forecastNextDays {
    _$forecastNextDaysAtom.reportRead();
    return super.forecastNextDays;
  }

  @override
  set forecastNextDays(List<ForecastDay> value) {
    _$forecastNextDaysAtom.reportWrite(value, super.forecastNextDays, () {
      super.forecastNextDays = value;
    });
  }

  late final _$countriesListAtom =
      Atom(name: '_ForecastStore.countriesList', context: context);

  @override
  List<Country> get countriesList {
    _$countriesListAtom.reportRead();
    return super.countriesList;
  }

  @override
  set countriesList(List<Country> value) {
    _$countriesListAtom.reportWrite(value, super.countriesList, () {
      super.countriesList = value;
    });
  }

  late final _$statesListAtom =
      Atom(name: '_ForecastStore.statesList', context: context);

  @override
  ObservableList<String> get statesList {
    _$statesListAtom.reportRead();
    return super.statesList;
  }

  @override
  set statesList(ObservableList<String> value) {
    _$statesListAtom.reportWrite(value, super.statesList, () {
      super.statesList = value;
    });
  }

  late final _$UpdateLocationAsyncAction =
      AsyncAction('_ForecastStore.UpdateLocation', context: context);

  @override
  Future<void> UpdateLocation() {
    return _$UpdateLocationAsyncAction.run(() => super.UpdateLocation());
  }

  late final _$UpdateForecastAsyncAction =
      AsyncAction('_ForecastStore.UpdateForecast', context: context);

  @override
  Future<void> UpdateForecast() {
    return _$UpdateForecastAsyncAction.run(() => super.UpdateForecast());
  }

  late final _$UpdateNextDaysAsyncAction =
      AsyncAction('_ForecastStore.UpdateNextDays', context: context);

  @override
  Future<void> UpdateNextDays() {
    return _$UpdateNextDaysAsyncAction.run(() => super.UpdateNextDays());
  }

  late final _$UpdateCountriesAsyncAction =
      AsyncAction('_ForecastStore.UpdateCountries', context: context);

  @override
  Future<void> UpdateCountries() {
    return _$UpdateCountriesAsyncAction.run(() => super.UpdateCountries());
  }

  late final _$RetrieveStatesAsyncAction =
      AsyncAction('_ForecastStore.RetrieveStates', context: context);

  @override
  Future<void> RetrieveStates(String country) {
    return _$RetrieveStatesAsyncAction.run(() => super.RetrieveStates(country));
  }

  @override
  String toString() {
    return '''
country: ${country},
avgTemp: ${avgTemp},
focusedHourForecast: ${focusedHourForecast},
forecastHour: ${forecastHour},
forecastNextDays: ${forecastNextDays},
countriesList: ${countriesList},
statesList: ${statesList}
    ''';
  }
}
