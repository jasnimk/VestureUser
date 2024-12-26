import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_bloc.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_event.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_state.dart';
import 'package:vesture_firebase_user/screens/login_screen.dart';
import 'package:vesture_firebase_user/screens/main_screen.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/custom_snackbar.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(userId: state.userId!),
            ),
          );
        } else if (state.status == AuthStatus.error) {
          CustomSnackBar.show(
            context,
            message: 'Sign up failed, Try again with valid credentials!',
            //backgroundColor: Colors.green, // Custom background color
            textColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.loading) {
          return Scaffold(
            body: Center(
                child: customSpinkitLoaderWithType(
              context: context,
              type: SpinkitType.chasingDots,
              color: Colors.red,
              size: 60.0,
            )),
          );
        }

        return Scaffold(
          appBar: buildCustomAppBar(
              title: 'SignUp', context: context, showBackButton: false),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/Images/logoooo.png'),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Enter your name',
                        border: OutlineInputBorder()),
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 15,
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
                    text: 'SignUp',
                    onPressed: state.status == AuthStatus.loading
                        ? () {}
                        : () {
                            context.read<AuthBloc>().add(
                                  SignUpRequested(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          },
                    height: 50,
                    context: context,
                    borderRadius: 30,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text('Already have an account? Login',
                        style: TextStyle(
                            fontFamily: 'Poppins-SemiBold',
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(GoogleSignInRequested());
                    },
                    icon: Icon(
                      FontAwesomeIcons.google,
                      color: Theme.of(context).textTheme.labelLarge!.color,
                    ),
                    label: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontFamily: 'Poppins-SemiBold',
                        color: Theme.of(context).textTheme.labelLarge!.color,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
