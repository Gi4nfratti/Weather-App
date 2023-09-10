import 'package:country_state_city/country_state_city.dart' as countryP;

import '../models/country.dart';

class CountriesListPageController {
  Future<List<Country>> retrieveCountriesList() async {
    List<Country> countriesList = [];
    await countryP.getAllCountries().then((value) {
      value.forEach((country) => countriesList.add(Country(
            name: country.name,
            isoCode: country.isoCode,
          )));
    });
    return countriesList;
  }
}
