import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather/models/forecast_day.dart';
import 'package:weather/models/forecast_hour.dart';

import '../models/forecast.dart';

class NextDaysPage extends StatefulWidget {
  const NextDaysPage({super.key});

  @override
  State<NextDaysPage> createState() => _NextDaysPageState();
}

class _NextDaysPageState extends State<NextDaysPage> {
  final List<ForecastDay> forecastNextDays = [];
  List<bool> _isOpen = [];

  @override
  void initState() {
    getNextDaysForecast();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.tertiary,
                ])),
            child: forecastNextDays.length == 0
                ? CircularProgressIndicator()
                : Container(child: _createExpansionPanel()),
          ),
        )));
  }

  Future<void> getNextDaysForecast() async {
    await http
        .get(Uri.parse(
            'https://api.weatherapi.com/v1/forecast.json?key=f54f33c40a3f4c27b0431302231106&q=London&days=3&aqi=no&alerts=no'))
        .then((response) {
      setState(() {
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

        print(forecastNextDays[0].avgTemp);
        print(forecastNextDays[0].avghumidity);
        print(forecastNextDays[0].date);
        print(forecastNextDays[0].maxTemp);
        print(forecastNextDays[0].minTemp);
        print(forecastNextDays[0].totalPrecip);
        print('\n\n\n\n');
        print(
            '${forecastNextDays[0].forecastHour[0].time} -- ${forecastNextDays[0].forecastHour[0].avgTemp}');
      });
    });
  }

  List<ForecastHour> _setForecastHourList(dynamic forecastDay) {
    List<ForecastHour> forecastHour = [];

    for (var hour in forecastDay['hour']) {
      forecastHour.add(ForecastHour(
          time: hour['time'],
          icon: Icon(Icons.cloud),
          avgTemp: hour['temp_c'].toString()));
    }
    return forecastHour;
  }

  ExpansionPanelList _createExpansionPanel() {
    final format = new DateFormat('dd/MM');
    for (var i = 0; i < forecastNextDays.length; i++) {
      _isOpen.add(false);
    }
    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.symmetric(horizontal: 10),
      expansionCallback: (i, isExpanded) {
        setState(() {
          _isOpen[i] = !isExpanded;
        });
      },
      children: forecastNextDays
          .map<ExpansionPanel>((item) => ExpansionPanel(
                isExpanded: _isOpen[forecastNextDays.indexOf(item)],
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: Text(format.format(DateTime.parse(item.date)),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 22)),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [MountDayForecastDetails(item)],
                ),
              ))
          .toList(),
    );
  }

  Widget MountDayForecastDetails(ForecastDay day) {
    final format = new DateFormat.Hm();
    TextStyle style = TextStyle(
        fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 18);

    return Center(
      child: Column(children: [
        Text("Temperatura Média: ${day.avgTemp}ºC", style: style),
        Text("Umidade: ${day.avghumidity}", style: style),
        Text("Mínima: ${day.minTemp}ºC", style: style),
        Text("Máxima: ${day.maxTemp}ºC", style: style),
        Text("Precipitação: ${day.totalPrecip}mm", style: style),
        SizedBox(
          height: 100,
          child: PageView.builder(
              scrollDirection: Axis.horizontal,
              padEnds: false,
              itemCount: day.forecastHour.length,
              controller: PageController(
                viewportFraction: 0.5,
              ),
              itemBuilder: (context, i) {
                return Transform.translate(
                  offset: Offset.zero,
                  child: Card(
                    color: Color(0xBBFFFFFF),
                    shadowColor: Color(0xAA000000),
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            format.format(DateTime.parse(
                                day.forecastHour[i].time.toString())),
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 16)),
                        SizedBox(height: 5),
                        day.forecastHour[i].icon,
                        SizedBox(height: 5),
                        Text("${day.forecastHour[i].avgTemp}ºC",
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 16))
                      ],
                    )),
                  ),
                );
              }),
        ),
      ]),
    );
  }
}
