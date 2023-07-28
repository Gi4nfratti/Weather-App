import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart' as statesP;
import 'package:weather/utils/appRoutes.dart';
import 'package:weather/views/home_page.dart';

class StatesPage extends StatefulWidget {
  StatesPage({super.key});

  @override
  State<StatesPage> createState() => _StatesPageState();
}

class _StatesPageState extends State<StatesPage> {
  List<String> statesList = [];

  @override
  void didChangeDependencies() {
    String country = ModalRoute.of(context)?.settings.arguments as String;
    retrieveStates(country);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: statesList.length == 0
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: statesList.length,
                    itemBuilder: (context, index) => GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(statesList[index],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              )),
                        ),
                        onTap: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (c) => HomePage(),
                                settings: RouteSettings(
                                    name: '/home',
                                    arguments: statesList[index])),
                            (route) => false))),
          ),
        ));
  }

  Future<void> retrieveStates(String country) async {
    try {
      await statesP.getStatesOfCountry(country).then((value) {
        setState(() {
          value.forEach((state) => statesList.add(state.name));
        });
      });
    } catch (ex) {
      print(ex);
    }
  }
}
