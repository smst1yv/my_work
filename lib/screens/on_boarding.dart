import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_app/screens/login_screen.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  Future<void> _markOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Title of introduction page",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Hello Team Work Time",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              image: Center(child: Image.asset('assets/splash_logo.jpg',fit: BoxFit.fitWidth,)),
            ),
            PageViewModel(
              title: "Title of introduction page",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Hello Team Work Time",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              image: Center(child: Image.asset('assets/splash_logo.jpg',fit: BoxFit.fitWidth,)),
            ),
            PageViewModel(
              title: "Title of introduction page",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Hello Team Work Time",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              image: Center(child: Image.asset('assets/splash_logo.jpg',fit: BoxFit.fitWidth,)),
            )
          ],
          onDone: () {
            _markOnboardingAsSeen();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          onSkip: () {
            _markOnboardingAsSeen();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          showNextButton: true,
          next: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
          done: const Text(
            "Done",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Theme.of(context).colorScheme.secondary,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
