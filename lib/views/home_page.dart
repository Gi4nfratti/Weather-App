import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:weather/store/forecast_store.dart';
import 'package:weather/utils/appRoutes.dart';
import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ForecastStore store;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    store = Provider.of<ForecastStore>(context);
    store.UpdateLocation().whenComplete(() => store.UpdateForecast());
    TextStyle forecastHourStyle =
        TextStyle(fontFamily: 'Poppins', fontSize: 16);

    return Scaffold(
      body: Observer(
        builder: (context) => Container(
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
          child: store.country.isEmpty
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
                            store.country,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            store.avgTemp,
                            style: TextStyle(color: Colors.white, fontSize: 68),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: Center(
                            child: SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width - 100,
                              child: store.forecastHour.length == 0
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
                                      itemCount: store.forecastHour.length,
                                      controller: PageController(
                                        initialPage: store.focusedHourForecast,
                                        viewportFraction: 0.5,
                                      ),
                                      itemBuilder: (context, i) {
                                        return Transform.translate(
                                          offset: Offset.zero,
                                          child: Card(
                                            color: const Color(0xBBFFFFFF),
                                            shadowColor:
                                                const Color(0xAA000000),
                                            elevation: 6,
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
                                                Text(store.forecastHour[i].time,
                                                    style: forecastHourStyle),
                                                SizedBox(height: 5),
                                                Image.network(
                                                  'https:${store.forecastHour[i].iconURL}',
                                                  cacheHeight: 32,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                    store.forecastHour[i]
                                                        .avgTemp,
                                                    style: forecastHourStyle)
                                              ],
                                            )),
                                          ),
                                        );
                                      }),
                            ),
                          ),
                        ),
                        Container(
                          child: ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            children: [
                              generateIconButton(
                                () => Navigator.of(context)
                                    .pushNamed(AppRoutes.NEXT_DAYS),
                                Icons.calendar_month_outlined,
                              ),
                              generateIconButton(
                                () => Navigator.of(context)
                                    .pushNamed(AppRoutes.COUNTRIES),
                                Icons.public_rounded,
                              ),
                              _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )
                                  : generateIconButton(
                                      () => GeneratePDF(),
                                      Icons.picture_as_pdf_rounded,
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  IconButton generateIconButton(Function() func, IconData icon) {
    return IconButton(
      onPressed: func,
      icon: Icon(
        icon,
        color: Colors.grey.shade800,
        weight: 20,
        size: 32,
      ),
    );
  }

  Future<void> GeneratePDF() async {
    setState(() => _isLoading = true);
    final textStyleTitle = pw.TextStyle(
      font: pw.Font.helveticaBold(),
      fontSize: 42,
    );

    final textStyle = pw.TextStyle(
      font: pw.Font.helvetica(),
      fontSize: 22,
    );
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
            child: pw.Column(children: [
          pw.Text('${store.country} - ${store.avgTemp}', style: textStyleTitle),
          pw.SizedBox(height: 20),
          pw.ListView(
              children: store.forecastHour
                  .map((hour) => pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(hour.time, style: textStyle),
                            pw.SizedBox(width: 50),
                            pw.Text(hour.avgTemp, style: textStyle),
                          ]))
                  .toList()),
        ])),
      ),
    );

    await Printing.sharePdf(
            bytes: await pdf.save(), filename: 'forecast-${store.country}.pdf')
        .whenComplete(() {
      setState(() => _isLoading = false);
    });
  }
}
