// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_bloc.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_state.dart';
import 'package:vesture_firebase_user/screens/login_screen.dart';
import 'package:vesture_firebase_user/screens/main_screen.dart';
import 'package:vesture_firebase_user/screens/on_boarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(-0.2, 0.1),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final bool hasCompletedOnboarding =
          prefs.getBool('onboarding_complete') ?? false;
      final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final String? loginMethod = prefs.getString('login_method');
      final String? userEmail = prefs.getString('user_email');

      log('Splash Screen Navigation Debug:');
      log('Onboarding Completed: $hasCompletedOnboarding');
      log('Is Logged In: $isLoggedIn');
      log('Login Method: $loginMethod');
      log('User Email: $userEmail');

      final currentUser = FirebaseAuth.instance.currentUser;
      log('Current Firebase User: ${currentUser?.uid}');

      if (!mounted) {
        log('Widget not mounted, returning');
        return;
      }

      if (!hasCompletedOnboarding) {
        log('Navigating to Onboarding Screen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      } else if (currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(userId: currentUser.uid),
          ),
        );
      } else {
        log('Navigating to Login Screen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      log('Navigation error: $e');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(userId: state.userId!),
              ),
            );
          });
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.errorMessage ?? 'Authentication failed')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/Images/image1.png',
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SlideTransition(
                    position: _positionAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: child,
                    ),
                  );
                },
                child: SizedBox(
                  width: 280,
                  height: 180,
                  child: Image.asset('assets/Images/image2.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
