import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart' as countryP;
import 'package:weather/utils/appRoutes.dart';

import '../models/country.dart';

class CountriesListPage extends StatefulWidget {
  const CountriesListPage({super.key});

  @override
  State<CountriesListPage> createState() => _CountriesListPageState();
}

class _CountriesListPageState extends State<CountriesListPage> {
  List<Country> countriesList = [];

  @override
  void initState() {
    retrieveCountriesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: countriesList.length == 0
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: countriesList.length,
                      itemBuilder: (context, index) => GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(countriesList[index].name,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              )),
                        ),
                        onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.STATES,
                            arguments: countriesList[index].isoCode),
                      ),
                    )),
        ),
      ),
    );
  }

  Future<void> retrieveCountriesList() async {
    await countryP.getAllCountries().then((value) {
      setState(() {
        value.forEach((country) => countriesList.add(Country(
              name: country.name,
              isoCode: country.isoCode,
            )));
      });
    });
  }
}
