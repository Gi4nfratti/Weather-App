import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather/dummy_data.dart';
import 'package:weather/utils/appRoutes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 60),
        child: PageView(
          
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          controller: controller,
          
          children: [
            GenerateOnboardingPage('onboardingImg1', onboardingTexts[0]),
            GenerateOnboardingPage('onboardingImg2', onboardingTexts[1]),
            GenerateOnboardingPage('onboardingImg3', onboardingTexts[2]),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: LinearBorder(),
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                minimumSize: Size.fromHeight(60),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
                Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vamos lá',
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ))
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: WormEffect(
                        spacing: 16,
                        dotColor: Theme.of(context).colorScheme.primary,
                        activeDotColor:
                            Theme.of(context).colorScheme.primaryContainer),
                    onDotClicked: (i) => controller.animateToPage(i,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget GenerateOnboardingPage(String imgSource, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        children: [
          Image.asset(
            'lib/images/${imgSource}.jpg',
            filterQuality: FilterQuality.high,
            alignment: Alignment.center,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 20,
                )),
          )
        ],
      ),
    ],
  );
}
