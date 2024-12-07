
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vesture_firebase_user/bloc/bloc/userprofile_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/userprofile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ProfileBloc({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }


  Future<void> _onFetchProfile(
      FetchProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final userName = userDoc['name'] ?? 'Unknown';
          final storedImagePath = userDoc['imageUrl'] ?? '';
          final email = userDoc['email'] ?? 'No email';
          final createdAt = userDoc['createdAt']?.toDate() ?? DateTime.now();

            if (storedImagePath.isNotEmpty) {
            if (!Uri.parse(storedImagePath).isAbsolute) {
              print('Warning: Invalid image URL.');
            }
          }

          emit(ProfileLoaded(
            name: userName,
            email: email,
            imageUrl: storedImagePath,
            createdAt: createdAt,
          ));
        } else {
          emit(ProfileError('User data not found.'));
        }
      } else {
        emit(ProfileError('User is not authenticated.'));
      }
    } catch (e) {
      print('Error fetching profile: $e');
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final userDocRef = _firestore.collection('users').doc(user.uid);
        Map<String, dynamic> updatedData = {};

        if (event.name != null && event.name!.isNotEmpty) {
          updatedData['name'] = event.name;
        }

        if (event.imageUrl != null && event.imageUrl!.isNotEmpty) {
           final bytes = base64Decode(event.imageUrl!);
          final Directory appDir = await getApplicationDocumentsDirectory();
          final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final String permanentPath = '${appDir.path}/$fileName';

          final File imageFile = File(permanentPath);
          await imageFile.writeAsBytes(bytes);

          updatedData['imageUrl'] = permanentPath;
          print('Saved image path to Firestore: $permanentPath');
        }

        if (updatedData.isNotEmpty) {
          try {
            await userDocRef.update(updatedData);
            print('Successfully updated user document');
          } catch (updateError) {
            print('Error updating user document: $updateError');
            emit(ProfileError('Failed to update profile: $updateError'));
            return;
          }
        }

       
        final updatedUserDoc = await userDocRef.get();
        final updatedName = updatedUserDoc['name'] ?? 'Unknown';
        final updatedImageUrl = updatedUserDoc['imageUrl'] ?? '';
        final updatedEmail = updatedUserDoc['email'] ?? 'No email';
        final updatedCreatedAt =
            updatedUserDoc['createdAt']?.toDate() ?? DateTime.now();

        emit(ProfileLoaded(
          name: updatedName,
          email: updatedEmail,
          imageUrl: updatedImageUrl,
          createdAt: updatedCreatedAt,
        ));
      } else {
        emit(ProfileError('User is not authenticated.'));
      }
    } catch (e) {
      print('Unexpected error in profile update: $e');
      emit(ProfileError('Failed to update profile: $e'));
    }
  }
}