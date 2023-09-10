import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:weather/store/forecast_store.dart';

import 'home_page.dart';

class StatesPage extends StatelessWidget {
  StatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final store = Provider.of<ForecastStore>(context);
    store.RetrieveStates(args);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Observer(
          builder: (context) => Center(
              child: store.statesList.length == 0
                  ? CircularProgressIndicator()
                  : Observer(
                      builder: (context) => ListView.builder(
                          itemCount: store.statesList.length,
                          itemBuilder: (context, index) => GestureDetector(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(store.statesList[index],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                    )),
                              ),
                              onTap: () {
                                store.country = store.statesList[index];
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => HomePage(),
                                        settings: RouteSettings(name: '/home')),
                                    (route) => false);
                              })),
                    )),
        ),
      ),
    );
  }
}
