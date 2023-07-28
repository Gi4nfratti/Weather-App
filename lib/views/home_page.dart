import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/forecast_hour.dart';
import 'package:weather/utils/appRoutes.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ForecastHour> forecastHour = [];
  int focusedHourForecast = 0;
  bool isAllowed = false;
  String country = "";
  String avgTemp = "";

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)?.settings.arguments == null) {
      GetCountryByLocation().then((value) {
        country = value!;
        getTodaysWeather(country);
      });
    } else {
      country = ModalRoute.of(context)?.settings.arguments as String;
      getTodaysWeather(country);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      persistentFooterButtons: [
        IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.NEXT_DAYS),
            icon: Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 32,
            )),
        IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.COUNTRIES),
            icon: Icon(
              Icons.public_rounded,
              color: Colors.white,
              size: 32,
            )),
      ],
      body: SafeArea(
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
          child: country.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            country,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            avgTemp,
                            style: TextStyle(color: Colors.white, fontSize: 68),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Center(
                        child: SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width - 100,
                          child: forecastHour.length == 0
                              ? Center(
                                  child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ))
                              : PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padEnds: false,
                                  itemCount: forecastHour.length,
                                  controller: PageController(
                                    initialPage: focusedHourForecast,
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(forecastHour[i].time,
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16)),
                                            SizedBox(height: 5),
                                            forecastHour[i].icon,
                                            SizedBox(height: 5),
                                            Text(forecastHour[i].avgTemp,
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16))
                                          ],
                                        )),
                                      ),
                                    );
                                  }),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> getTodaysWeather(String country) async {
    forecastHour.clear();
    await http
        .get(Uri.parse(
            'http://api.weatherapi.com/v1/forecast.json?key=f54f33c40a3f4c27b0431302231106&q=${country}&days=1&aqi=no&alerts=no'))
        .then((response) {
      setState(() {
        var json = jsonDecode(response.body);
        for (var hour in json['forecast']['forecastday'][0]['hour']) {
          forecastHour.add(ForecastHour(
              avgTemp: '${hour['temp_c']}ºC',
              time: (hour['time'] as String).substring(11),
              icon: Icon(Icons.cloud_outlined)));
        }
        avgTemp = '${json['current']['temp_c']}ºC';
        var lastUpdated =
            (json['current']['last_updated'] as String).substring(11, 13);
        focusedHourForecast = forecastHour
            .indexWhere((e) => e.time.substring(0, 2) == lastUpdated);
      });
    });
  }

  Future<String?> GetCountryByLocation() async {
    final v = await Geolocator.getCurrentPosition();
    var addr = await placemarkFromCoordinates(v.latitude, v.longitude);
    return addr[0].administrativeArea;
  }
}
