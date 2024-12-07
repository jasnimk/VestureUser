import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesture_firebase_user/screens/login_screen.dart';
import 'package:vesture_firebase_user/screens/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

void _markOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Explicitly set onboarding as complete
  await prefs.setBool('onboarding_complete', true);

  // Explicitly navigate to LoginScreen and clear previous routes
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            isLastPage = page == 2;
          });
        },
        children: [
          _buildPage(
            title: '''Fun, Comfortable, 
and Stylish👕🎈''',
            description:
                'Trendy clothing for your little ones, designed to move with them',
            image: 'assets/Images/kids1.jpg',
            isLastPage: false,
            pageController: _pageController,
            onComplete: _markOnboardingComplete,
          ),
          _buildPage(
            title: 'Define Your Look👔👞',
            description:
                'Classic and contemporary styles, crafted for men with confidence.',
            image: 'assets/Images/men3.jpg',
            isLastPage: false,
            pageController: _pageController,
            onComplete: _markOnboardingComplete,
          ),
          _buildPage(
            title: '''Unleash Your Inner 
Chic💃💫''',
            description: 'Sophisticated styles, designed for the modern woman.',
            image: 'assets/Images/women2.jpg',
            isLastPage: true,
            pageController: _pageController,
            onComplete: _markOnboardingComplete,
          ),
        ],
      ),
    );
  }

  _buildPage({
    required String title,
    required String description,
    required String image,
    required bool isLastPage,
    required PageController pageController,
    required VoidCallback onComplete,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black54,
                Colors.transparent,
                Colors.black54,
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 50,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  description,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontFamily: 'Poppins-SemiBold'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onComplete,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Poppins-Bold'),
                ),
              ),
              ElevatedButton(
                onPressed: isLastPage
                    ? onComplete
                    : () {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: Text(
                  isLastPage ? 'Done' : 'Next',
                  style:
                      const TextStyle(fontFamily: 'Poppins-Bold', fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
