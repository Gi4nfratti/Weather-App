import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather/dummy_data.dart';

import '../models/forecast.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Forecast forecast;
  int _index = 0;
  @override
  void initState() {
    forecast = Forecast(
      forecastDay: forecastDayListTest,
      city: "São Paulo",
      country: "Brasil",
      localtime: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SÃO PAULO',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      '19°C',
                      style: TextStyle(color: Colors.black, fontSize: 68),
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
                    child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: forecast.forecastDay
                            .where((e) =>
                                e.date ==
                                DateFormat('dd-MM-yyyy').format(DateTime.now()))
                            .map((v) => v.forecastHour)
                            .length,
                        controller: PageController(
                          viewportFraction: 0.5,
                        ),
                        onPageChanged: (int index) =>
                            setState(() => _index = index),
                        itemBuilder: (context, i) {
                          return Transform.scale(
                            scale: i == _index ? 1 : 0.9,
                            child: Card(
                              elevation: 20,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  "Card",
                                  style: TextStyle(fontSize: 32),
                                ),
                              ),
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
}
