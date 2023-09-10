import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:weather/controllers/nextdayspage_controller.dart';
import 'package:weather/models/forecast_day.dart';
import 'package:pdf/widgets.dart' as pw;

import '../store/forecast_store.dart';

class NextDaysPage extends StatefulWidget {
  const NextDaysPage({super.key});

  @override
  State<NextDaysPage> createState() => _NextDaysPageState();
}

class _NextDaysPageState extends State<NextDaysPage> {
  bool _isLoading = false;
  NextDaysPageController controller = NextDaysPageController();
  final format = new DateFormat('dd/MM');
  final formatTime = new DateFormat.Hm();
  List<bool> _isOpen = [];
  late ForecastStore store;
  @override
  void didChangeDependencies() async {
    store = Provider.of<ForecastStore>(context);
    store.UpdateNextDays();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: GeneratePDF,
                    icon: Icon(Icons.picture_as_pdf_rounded))
          ],
        ),
        body: Observer(
          builder: (context) => SafeArea(
              child: store.forecastNextDays.length == 0
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Container(
                          color: Colors.white,
                          child: _createExpansionPanel(context)),
                    )),
        ));
  }

  ExpansionPanelList _createExpansionPanel(BuildContext context) {
    final store = Provider.of<ForecastStore>(context);
    for (var i = 0; i < store.forecastNextDays.length; i++) {
      _isOpen.add(false);
    }
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.symmetric(horizontal: 10),
      expansionCallback: (i, isExpanded) {
        setState(() {
          _isOpen[i] = !isExpanded;
        });
      },
      children: store.forecastNextDays
          .map<ExpansionPanel>((item) => ExpansionPanel(
                backgroundColor: Colors.white,
                isExpanded: _isOpen[store.forecastNextDays.indexOf(item)],
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
                        Image.network(
                          'https:${day.forecastHour[i].iconURL}',
                          cacheHeight: 32,
                        ),
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
    setState(() => _isLoading = true);
    final textStyleTitle = pw.TextStyle(
      font: pw.Font.helveticaBold(),
      fontSize: 32,
    );

    final textStyle = pw.TextStyle(
      font: pw.Font.helvetica(),
      fontSize: 18,
    );
    final pdf = pw.Document();
    for (var day in store.forecastNextDays) {
      pdf.addPage(pw.Page(
        build: (context) => pw.Center(
            child: pw.Column(children: [
          pw.Text(
              '${store.country} - ${format.format(DateTime.parse(day.date))}',
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
            bytes: await pdf.save(), filename: 'forecast-${store.country}.pdf')
        .whenComplete(() {
      setState(() => _isLoading = false);
    });
  }
}
