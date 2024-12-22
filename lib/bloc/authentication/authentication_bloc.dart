import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_event.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthBloc({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        super(AuthState.initial()) {
    on<SignUpRequested>(_onSignUp);
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<AuthCheckRequested>(_onAuthCheck);
    on<GoogleSignInRequested>(_onGoogleSignIn);

    add(AuthCheckRequested());
  }
  Future<void> _onGoogleSignIn(
      GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthState.unauthenticated());
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('login_method', 'google');
      await prefs.setString('user_email', userCredential.user!.email!);
      final userDocRef =
          _firestore.collection('users').doc(userCredential.user!.uid);

      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;

        bool isBlocked = userData['isBlocked'] ?? false;
        if (isBlocked) {
          emit(AuthState.unauthenticated());
          return;
        }

        Map<String, dynamic> updateFields = {};
        if (!userData.containsKey('imageUrl')) {
          updateFields['imageUrl'] = '';
        }
        if (!userData.containsKey('isBlocked')) {
          updateFields['isBlocked'] = false;
        }

        if (updateFields.isNotEmpty) {
          await userDocRef.update(updateFields);
        }
      } else {
        await userDocRef.set({
          'name': googleUser.displayName,
          'email': googleUser.email,
          'createdAt': FieldValue.serverTimestamp(),
          'imageUrl': '',
          'isBlocked': false,
        });
      }

      String displayName = userCredential.user!.displayName ?? 'User';
      emit(AuthState.authenticated(userCredential.user!.uid, displayName));
    } catch (e) {
      log('Google Sign-In Error: $e');
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onAuthCheck(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        var userData = userDoc.data();

        if (userData?['isBlocked'] == true) {
          await _firebaseAuth.signOut();
          emit(AuthState.unauthenticated());
        } else {
          emit(AuthState.authenticated(user.uid, user.displayName!));
        }
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': event.name,
        'email': event.email,
        'createdAt': FieldValue.serverTimestamp(),
        'isBlocked': false,
        'imageUrl': '',
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_email', event.email);
      await prefs.setString('login_method', 'email');

      String displayName = userCredential.user!.displayName ?? 'User';
      emit(AuthState.authenticated(userCredential.user!.uid, displayName));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final userDocRef =
          _firestore.collection('users').doc(userCredential.user!.uid);

      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;

        bool isBlocked = userData['isBlocked'] ?? false;
        if (isBlocked) {
          emit(AuthState.error(
              "Your account has been blocked. Please contact support."));
          return;
        }

        Map<String, dynamic> updateFields = {};
        if (!userData.containsKey('imageUrl')) {
          updateFields['imageUrl'] = '';
        }
        if (!userData.containsKey('isBlocked')) {
          updateFields['isBlocked'] = false;
        }

        if (updateFields.isNotEmpty) {
          await userDocRef.update(updateFields);
        }
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_email', event.email);

      await prefs.setString('login_method', 'email');

      String displayName = userCredential.user!.displayName ?? 'User';
      emit(AuthState.authenticated(userCredential.user!.uid, displayName));
    } catch (e) {
      emit(AuthState.error("Invalid email or password. Please try again."));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_logged_in');
      await prefs.remove('user_email');

      await _firebaseAuth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
    } catch (e) {
      log('Logout Error: $e');
    } finally {
      emit(AuthState.unauthenticated());
    }
  }
}
