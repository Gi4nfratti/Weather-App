import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:weather/store/forecast_store.dart';
import 'package:weather/utils/appRoutes.dart';

class CountriesListPage extends StatelessWidget {
  CountriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ForecastStore>(context);
    store.UpdateCountries();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Observer(
          builder: (context) => Center(
              child: store.countriesList.length == 0
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: store.countriesList.length,
                      itemBuilder: (context, index) => GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(store.countriesList[index].name,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              )),
                        ),
                        onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.STATES,
                            arguments: store.countriesList[index].isoCode),
                      ),
                    )),
        ),
      ),
    );
  }
}
