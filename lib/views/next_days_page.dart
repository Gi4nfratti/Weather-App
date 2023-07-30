import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:weather/models/forecast_day.dart';
import 'package:weather/models/forecast_hour.dart';
import 'package:weather/views/home_page.dart';
import 'package:weather/auth/keysSecret.dart' as keysSecret;
import 'package:pdf/widgets.dart' as pw;

class NextDaysPage extends StatefulWidget {
  const NextDaysPage({super.key});

  @override
  State<NextDaysPage> createState() => _NextDaysPageState();
}

class _NextDaysPageState extends State<NextDaysPage> {
  final List<ForecastDay> forecastNextDays = [];
  final format = new DateFormat('dd/MM');
  final formatTime = new DateFormat.Hm();
  List<bool> _isOpen = [];

  @override
  void initState() {
    getNextDaysForecast();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: GeneratePDF,
                icon: Icon(Icons.picture_as_pdf_rounded))
          ],
        ),
        body: SafeArea(
            child: forecastNextDays.length == 0
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Container(
                        color: Colors.white, child: _createExpansionPanel()),
                  )));
  }

  Future<void> getNextDaysForecast() async {
    print(HomePage.country);
    await http
        .get(Uri.parse(
            'https://api.weatherapi.com/v1/forecast.json?key=${keysSecret.key}&q=${HomePage.country}&days=3&aqi=no&alerts=no'))
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
    for (var i = 0; i < forecastNextDays.length; i++) {
      _isOpen.add(false);
    }
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.symmetric(horizontal: 10),
      expansionCallback: (i, isExpanded) {
        setState(() {
          _isOpen[i] = !isExpanded;
        });
      },
      children: forecastNextDays
          .map<ExpansionPanel>((item) => ExpansionPanel(
                backgroundColor: Colors.white,
                isExpanded: _isOpen[forecastNextDays.indexOf(item)],
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
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
    TextStyle style = TextStyle(
        fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 18);

    return Center(
      child: Column(children: [
        Text("Temperatura Média: ${day.avgTemp}ºC", style: style),
        Text("Umidade: ${day.avghumidity}%", style: style),
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
                            formatTime.format(DateTime.parse(
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

  Future<void> GeneratePDF() async {
    final textStyleTitle = pw.TextStyle(
      font: pw.Font.helveticaBold(),
      fontSize: 32,
    );

    final textStyle = pw.TextStyle(
      font: pw.Font.helvetica(),
      fontSize: 18,
    );
    final pdf = pw.Document();
    for (var day in forecastNextDays) {
      pdf.addPage(pw.Page(
        build: (context) => pw.Center(
            child: pw.Column(children: [
          pw.Text(
              '${HomePage.country} - ${format.format(DateTime.parse(day.date))}',
              style: textStyleTitle,
              textAlign: pw.TextAlign.center),
          pw.Text('Mínima: ${day.minTemp}ºC',
              style: textStyleTitle, textAlign: pw.TextAlign.center),
          pw.Text('Máxima: ${day.maxTemp}ºC',
              style: textStyleTitle, textAlign: pw.TextAlign.center),
          pw.Text('Umidade: ${day.avghumidity}%',
              style: textStyleTitle, textAlign: pw.TextAlign.center),
          pw.Text('Precipitação: ${day.totalPrecip}mm',
              style: textStyleTitle, textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 20),
          pw.ListView(
              children: day.forecastHour
                  .map((hour) => pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                                formatTime.format(DateTime.parse(hour.time)),
                                style: textStyle),
                            pw.SizedBox(width: 50),
                            pw.Text(hour.avgTemp, style: textStyle),
                          ]))
                  .toList()),
        ])),
      ));
    }
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'forecast-${HomePage.country}.pdf');
  }
}
