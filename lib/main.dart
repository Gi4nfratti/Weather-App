import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/store/forecast_store.dart';
import 'package:weather/utils/appRoutes.dart';
import 'package:weather/views/countries_list_page.dart';
import 'package:weather/views/home_page.dart';
import 'package:weather/views/next_days_page.dart';
import 'package:weather/views/onboarding_page.dart';
import 'package:weather/views/states_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ForecastStore>(create: (context) => ForecastStore())
      ],
      child: MaterialApp(
        title: 'Weather',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color(0xFF99DBF5),
              secondary: Color(0xFFA7ECEE),
              tertiary: Color(0xFF9AC5F4),
            ),
            appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xFF99DBF5),
            ))),
        debugShowCheckedModeBanner: false,
        home: showHome ? HomePage() : OnboardingPage(),
        routes: {
          AppRoutes.HOME: (context) => HomePage(),
          AppRoutes.NEXT_DAYS: (context) => NextDaysPage(),
          AppRoutes.COUNTRIES: (context) => CountriesListPage(),
          AppRoutes.STATES: (context) => StatesPage(),
        },
      ),
    );
  }
}
