import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/bloc/bloc/userprofile_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/userprofile_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/userprofile_state.dart';
import 'package:vesture_firebase_user/bloc/cubit/theme_cubit.dart';
import 'package:vesture_firebase_user/bloc/cubit/theme_state.dart';
import 'package:vesture_firebase_user/screens/forgot_password.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/custom_capture.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      )..add(FetchProfile(userId: FirebaseAuth.instance.currentUser!.uid)),
      child: Scaffold(
        appBar: buildCustomAppBar(context: context, title: 'Settings'),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  final Completer<void> completer = Completer<void>();

                  try {
                    context.read<ProfileBloc>().add(
                          FetchProfile(
                            userId: FirebaseAuth.instance.currentUser!.uid,
                          ),
                        );

                    await Future.delayed(const Duration(seconds: 2));
                    completer.complete();
                  } catch (e) {
                    completer.completeError(e);
                  }

                  return completer.future;
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () {
                              showImageSourceDialog(context);
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: state.imageUrl.isNotEmpty
                                  ? FileImage(File(state.imageUrl))
                                  : const AssetImage(
                                          'assets/Images/profile.jpg')
                                      as ImageProvider,
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Poppins-Bold'),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showEditNameDialog(context, state.name);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Poppins-Bold'),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (ctx) {
                                      return const ForgotPassword();
                                    }));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Please Login Again!')),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Switch Mode',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                      fontFamily: 'Poppins-SemiBold',
                                      fontSize: 15)),
                              IconButton(
                                icon: Icon(
                                  context.watch<ThemeCubit>().state
                                          is DarkThemeState
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  color: context.watch<ThemeCubit>().state
                                          is DarkThemeState
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                onPressed: () {
                                  if (context.read<ThemeCubit>().state
                                      is DarkThemeState) {
                                    context.read<ThemeCubit>().switchToLight();
                                  } else {
                                    context.read<ThemeCubit>().switchToDark();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        textWidget('About US', context),
                        const SizedBox(height: 8),
                        textWidget('FAQs', context),
                        const SizedBox(height: 8),
                        textWidget('Support', context),
                        const SizedBox(height: 8),
                        textWidget('Privacy Policy', context),
                        const SizedBox(height: 20),
                        customButton(
                          context: context,
                          text: 'Logout',
                          height: 50,
                          onPressed: () {
                            showDeleteConfirmation(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                              FetchProfile(
                                userId: FirebaseAuth.instance.currentUser!.uid,
                              ),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
