import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_bloc.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_event.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_state.dart';
import 'package:vesture_firebase_user/screens/forgot_password.dart';
import 'package:vesture_firebase_user/screens/main_screen.dart';
import 'package:vesture_firebase_user/screens/signup_screen.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print('Auth Status: ${state.status}');

        if (state.status == AuthStatus.authenticated) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Welcome back, ${state.userName}!')),
          // );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                      userId: state.userId!,
                    )),
          );
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: buildCustomAppBar(
              title: 'Login', context: context, showBackButton: false),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 75,
                  ),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/Images/logoooo.png'),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Enter your email',
                        border: OutlineInputBorder()),
                    controller: emailController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Enter your password',
                        border: OutlineInputBorder()),
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  customButton(
                    text: 'Login',
                    onPressed: state.status == AuthStatus.loading
                        ? () {} // Empty function when loading (disabled button)
                        : () {
                            context.read<AuthBloc>().add(
                                  LoginRequested(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          },
                    height: 50,
                    context: context,
                    borderRadius: 30,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()),
                      );
                    },
                    child: const Text('forgot your password?'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
