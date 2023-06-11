import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/utils/appRoutes.dart';
import 'package:weather/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

/*
  COLOR PALETTE:
  #9AC5F4
  #99DBF5
  #A7ECEE
  #FFEEBB
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF99DBF5),
          secondary: Color(0xFFA7ECEE),
          tertiary:  Color(0xFF9AC5F4),
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF99DBF5),
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.HOME: (context) => HomePage(),
      },
    );
  }
}
