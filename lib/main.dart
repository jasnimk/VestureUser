import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/userprofile_bloc.dart';
import 'package:vesture_firebase_user/bloc/cubit/theme_cubit.dart';
import 'package:vesture_firebase_user/bloc/cubit/theme_state.dart';
import 'package:vesture_firebase_user/firebase_options.dart';
import 'package:vesture_firebase_user/screens/splash_screen.dart';
import 'package:vesture_firebase_user/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            firebaseAuth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            firestore: FirebaseFirestore.instance,
            firebaseAuth: FirebaseAuth.instance,
          ), 
        ),

        BlocProvider(
          create: (_) => ThemeCubit(), 
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
       
        ThemeData themeData = lightmode; 
        if (state is DarkThemeState) {
          themeData = darkmode; 
        }

        return MaterialApp(
          title: 'Vesture',
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: themeData, 
          darkTheme: darkmode, 
          themeMode: state is LightThemeState
              ? ThemeMode.light
              : ThemeMode.dark,
        );
      },
    );
  }
}
