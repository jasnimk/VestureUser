// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:vesture_firebase_user/bloc/authentication/authentication_bloc.dart';
// // import 'package:vesture_firebase_user/bloc/authentication/authentication_event.dart';
// // import 'package:vesture_firebase_user/bloc/authentication/authentication_state.dart';
// // import 'package:vesture_firebase_user/screens/login_screen.dart';
// // import 'package:vesture_firebase_user/screens/main_screen.dart';

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({Key? key}) : super(key: key);

// //   @override
// //   _SplashScreenState createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<Offset> _positionAnimation;
// //   late Animation<double> _scaleAnimation;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _controller = AnimationController(
// //       duration: const Duration(seconds: 3),
// //       vsync: this,
// //     );

// //     _positionAnimation = Tween<Offset>(
// //       begin: const Offset(0, -1),
// //       end: const Offset(-0.2, 0.1),
// //     ).animate(
// //       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
// //     );

// //     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
// //       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
// //     );

// //     _controller.forward();

// //     // Wait for the animation and simulate load time
// //     Future.delayed(const Duration(milliseconds: 4000), () {
// //       context
// //           .read<AuthBloc>()
// //           .add(LoginRequested(email: 'user@example.com', password: 'password'));
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocListener<AuthBloc, AuthState>(
// //       listener: (context, state) {
// //         if (state.status == AuthStatus.authenticated) {
// //           Future.delayed(const Duration(seconds: 3), () {
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => MainScreen(userId: state.userId!),
// //               ),
// //             );
// //           });
// //         } else if (state.status == AuthStatus.unauthenticated) {
// //           Future.delayed(const Duration(seconds: 3), () {
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(builder: (context) => LoginScreen()),
// //             );
// //           });
// //         }
// //       },
// //       child: Scaffold(
// //         body: Center(
// //           child: Stack(
// //             children: [
// //               // Background image
// //               Positioned.fill(
// //                 child: Image.asset(
// //                   'assets/Images/image1.png',
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //               // Animated logo
// //               AnimatedBuilder(
// //                 animation: _controller,
// //                 builder: (context, child) {
// //                   return SlideTransition(
// //                     position: _positionAnimation,
// //                     child: ScaleTransition(
// //                       scale: _scaleAnimation,
// //                       child: child,
// //                     ),
// //                   );
// //                 },
// //                 child: SizedBox(
// //                   width: 280,
// //                   height: 180,
// //                   child: Image.asset('assets/Images/image2.png'),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/authentication/authentication_bloc.dart';
// import 'package:vesture_firebase_user/bloc/authentication/authentication_event.dart';
// import 'package:vesture_firebase_user/bloc/authentication/authentication_state.dart';
// import 'package:vesture_firebase_user/screens/login_screen.dart';
// import 'package:vesture_firebase_user/screens/main_screen.dart';
// import 'package:vesture_firebase_user/screens/on_boarding.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _positionAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );

//     _positionAnimation = Tween<Offset>(
//       begin: const Offset(0, -1),
//       end: const Offset(-0.2, 0.1),
//     ).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );

//     _controller.forward();

//     // Wait for the animation and simulate load time
//     Future.delayed(const Duration(milliseconds: 4000), () {
//       _navigateToNextScreen();
//     });
//   }

//   Future<void> _navigateToNextScreen() async {
//     final prefs = await SharedPreferences.getInstance();
//     final bool hasCompletedOnboarding =
//         prefs.getBool('onboarding_complete') ?? false;
//     final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

//     if (!hasCompletedOnboarding) {
//       // If onboarding is not completed, navigate to the Onboarding screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => OnboardingScreen()),
//       );
//     } else if (isLoggedIn) {
//       // If user is logged in, navigate to the MainScreen
//       context.read<AuthBloc>().add(LoginRequested(
//             email: 'user@example.com',
//             password: 'password',
//           ));
//     } else {
//       // If user is not logged in, navigate to LoginScreen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state.status == AuthStatus.authenticated) {
//           Future.delayed(const Duration(seconds: 3), () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MainScreen(userId: state.userId!),
//               ),
//             );
//           });
//         } else if (state.status == AuthStatus.unauthenticated) {
//           Future.delayed(const Duration(seconds: 3), () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => OnboardingScreen()),
//             );
//           });
//         }
//       },
//       child: Scaffold(
//         body: Center(
//           child: Stack(
//             children: [
//               // Background image
//               Positioned.fill(
//                 child: Image.asset(
//                   'assets/Images/image1.png',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               // Animated logo
//               AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, child) {
//                   return SlideTransition(
//                     position: _positionAnimation,
//                     child: ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: SizedBox(
//                   width: 280,
//                   height: 180,
//                   child: Image.asset('assets/Images/image2.png'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


 // Future<void> _onAuthCheck(
  //     AuthCheckRequested event, Emitter<AuthState> emit) async {
  //   try {
  //     final user = _firebaseAuth.currentUser;
  //     if (user != null) {
  //       // Fetch user details from Firestore
  //       final userDoc =
  //           await _firestore.collection('users').doc(user.uid).get();

  //       // Check if the user is blocked
  //       var userData = userDoc.data() as Map<String, dynamic>?;
  //       bool isBlocked = userData?['isBlocked'] ?? false;

  //       if (isBlocked) {
  //         // If user is blocked, log out
  //         await _firebaseAuth.signOut();
  //         emit(state.copyWith(status: AuthStatus.unauthenticated));
  //       } else {
  //         emit(state.copyWith(
  //           status: AuthStatus.authenticated,
  //           userId: user.uid,
  //           userName: userDoc.exists ? userDoc['name'] : null,
  //         ));
  //       }
  //     } else {
  //       emit(state.copyWith(status: AuthStatus.unauthenticated));
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: AuthStatus.unauthenticated,
  //       errorMessage: 'Authentication check failed',
  //     ));
  //   }
  // }


   // Future<void> _onGoogleSignIn(
  //     GoogleSignInRequested event, Emitter<AuthState> emit) async {
  //   emit(state.copyWith(status: AuthStatus.loading));
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       emit(state.copyWith(
  //         status: AuthStatus.error,
  //         errorMessage: "Google Sign-In canceled.",
  //       ));
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     UserCredential userCredential =
  //         await _firebaseAuth.signInWithCredential(credential);

  //     DocumentSnapshot userDoc = await _firestore
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .get();

  //     if (userDoc.exists) {
  //       var userData = userDoc.data() as Map<String, dynamic>;

  //       // Check if the user is blocked
  //       bool isBlocked = userData['isBlocked'] ?? false;
  //       if (isBlocked) {
  //         emit(state.copyWith(
  //           status: AuthStatus.error,
  //           errorMessage:
  //               "Your account has been blocked. Please contact support.",
  //         ));
  //         return;
  //       }

  //       // Add default fields if missing
  //       if (!userData.containsKey('imageUrl')) {
  //         await _firestore
  //             .collection('users')
  //             .doc(userCredential.user!.uid)
  //             .update({
  //           'imageUrl': '', // Or a placeholder image URL
  //         });
  //       }
  //       if (!userData.containsKey('isBlocked')) {
  //         await _firestore
  //             .collection('users')
  //             .doc(userCredential.user!.uid)
  //             .update({
  //           'isBlocked': false,
  //         });
  //       }

  //       emit(state.copyWith(
  //         status: AuthStatus.authenticated,
  //         userId: userCredential.user!.uid,
  //         userName: userDoc['name'],
  //       ));
  //     } else {
  //       // Create a new user document with default values
  //       await _firestore.collection('users').doc(userCredential.user!.uid).set({
  //         'name': googleUser.displayName,
  //         'email': googleUser.email,
  //         'createdAt': FieldValue.serverTimestamp(),
  //         'imageUrl': '', // Default image URL
  //         'isBlocked': false, // Default blocked status
  //       });

  //       emit(state.copyWith(
  //         status: AuthStatus.authenticated,
  //         userId: userCredential.user!.uid,
  //         userName: googleUser.displayName,
  //       ));
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: AuthStatus.error,
  //       errorMessage: e.toString(),
  //     ));
  //   }
  // }

  // import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vesture_firebase_user/bloc/authentication/authentication_event.dart';
// import 'package:vesture_firebase_user/bloc/authentication/authentication_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final FirebaseAuth _firebaseAuth;
//   final FirebaseFirestore _firestore;
//   final GoogleSignIn _googleSignIn;

//   AuthBloc({
//     required FirebaseAuth firebaseAuth,
//     required FirebaseFirestore firestore,
//     GoogleSignIn? googleSignIn,
//   })  : _firebaseAuth = firebaseAuth,
//         _firestore = firestore,
//         _googleSignIn = googleSignIn ?? GoogleSignIn(),
//         super(const AuthState()) {
//     on<SignUpRequested>(_onSignUp);
//     on<LoginRequested>(_onLogin);
//     on<LogoutRequested>(_onLogout);
//     on<AuthCheckRequested>(_onAuthCheck);
//     on<GoogleSignInRequested>(_onGoogleSignIn);

//     add(AuthCheckRequested());
//   }
//   Future<void> _onGoogleSignIn(
//       GoogleSignInRequested event, Emitter<AuthState> emit) async {
//     emit(state.copyWith(status: AuthStatus.loading));
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         emit(state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: "Google Sign-In canceled.",
//         ));
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       DocumentSnapshot userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       if (userDoc.exists) {
//         var userData = userDoc.data() as Map<String, dynamic>;

//         // Check if the user is blocked
//         bool isBlocked = userData['isBlocked'] ?? false;
//         if (isBlocked) {
//           emit(state.copyWith(
//             status: AuthStatus.error,
//             errorMessage:
//                 "Your account has been blocked. Please contact support.",
//           ));
//           return;
//         }

//         // Add default fields if missing
//         if (!userData.containsKey('imageUrl')) {
//           await _firestore
//               .collection('users')
//               .doc(userCredential.user!.uid)
//               .update({
//             'imageUrl': '', // Or a placeholder image URL
//           });
//         }
//         if (!userData.containsKey('isBlocked')) {
//           await _firestore
//               .collection('users')
//               .doc(userCredential.user!.uid)
//               .update({
//             'isBlocked': false,
//           });
//         }

//         emit(state.copyWith(
//           status: AuthStatus.authenticated,
//           userId: userCredential.user!.uid,
//           userName: userDoc['name'],
//         ));
//       } else {
//         // Create a new user document with default values
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'name': googleUser.displayName,
//           'email': googleUser.email,
//           'createdAt': FieldValue.serverTimestamp(),
//           'imageUrl': '', // Default image URL
//           'isBlocked': false, // Default blocked status
//         });

//         emit(state.copyWith(
//           status: AuthStatus.authenticated,
//           userId: userCredential.user!.uid,
//           userName: googleUser.displayName,
//         ));
//       }
//     } catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: e.toString(),
//       ));
//     }
//   }

//   Future<void> _onAuthCheck(
//       AuthCheckRequested event, Emitter<AuthState> emit) async {
//     try {
//       final user = _firebaseAuth.currentUser;
//       if (user != null) {
//         // Fetch user details from Firestore
//         final userDoc =
//             await _firestore.collection('users').doc(user.uid).get();

//         // Check if the user is blocked
//         var userData = userDoc.data() as Map<String, dynamic>?;
//         bool isBlocked = userData?['isBlocked'] ?? false;

//         if (isBlocked) {
//           // If user is blocked, log out
//           await _firebaseAuth.signOut();
//           emit(state.copyWith(status: AuthStatus.unauthenticated));
//         } else {
//           emit(state.copyWith(
//             status: AuthStatus.authenticated,
//             userId: user.uid,
//             userName: userDoc.exists ? userDoc['name'] : null,
//           ));
//         }
//       } else {
//         emit(state.copyWith(status: AuthStatus.unauthenticated));
//       }
//     } catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.unauthenticated,
//         errorMessage: 'Authentication check failed',
//       ));
//     }
//   }

//   Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
//     if (event.name.isEmpty) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: "Name cannot be empty.",
//       ));
//       return;
//     }
//     if (event.email.isEmpty ||
//         !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
//             .hasMatch(event.email)) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: "Please enter a valid email.",
//       ));
//       return;
//     }
//     if (event.password.isEmpty || event.password.length < 6) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: "Password must be at least 6 characters long.",
//       ));
//       return;
//     }

//     emit(state.copyWith(status: AuthStatus.loading));
//     try {
//       UserCredential userCredential =
//           await _firebaseAuth.createUserWithEmailAndPassword(
//         email: event.email,
//         password: event.password,
//       );

//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'name': event.name,
//         'email': event.email,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       emit(state.copyWith(
//         status: AuthStatus.authenticated,
//         userId: userCredential.user!.uid,
//         userName: event.name,
//       ));
//     } on FirebaseAuthException catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: e.message ?? "Signup failed. Please try again.",
//       ));
//     }
//   }

//   Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
//     emit(state.copyWith(status: AuthStatus.loading));
//     try {
//       UserCredential userCredential =
//           await _firebaseAuth.signInWithEmailAndPassword(
//         email: event.email,
//         password: event.password,
//       );

//       // Store login credentials
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('is_logged_in', true);
//       await prefs.setString('user_email', event.email);
//       await prefs.setString('user_password', event.password);

//       DocumentSnapshot userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       // Check if the document exists and cast the data to Map<String, dynamic>
//       if (userDoc.exists) {
//         var userData = userDoc.data() as Map<String, dynamic>;

//         // Check if the user is blocked
//         bool isBlocked = userData['isBlocked'] ?? false;
//         if (isBlocked) {
//           // User is blocked, prevent login
//           emit(state.copyWith(
//             status: AuthStatus.error,
//             errorMessage:
//                 "Your account has been blocked. Please contact support.",
//           ));
//           return;
//         }

//         // If imageUrl doesn't exist, update the Firestore document with a default value
//         if (!userData.containsKey('imageUrl')) {
//           await _firestore
//               .collection('users')
//               .doc(userCredential.user!.uid)
//               .update({
//             'imageUrl': '', // Or you can use a placeholder image URL here
//           });
//         }

//         // If isBlocked field doesn't exist, add it with default value false
//         if (!userData.containsKey('isBlocked')) {
//           await _firestore
//               .collection('users')
//               .doc(userCredential.user!.uid)
//               .update({
//             'isBlocked': false,
//           });
//         }

//         // Emit the state with the user information from Firestore
//         emit(state.copyWith(
//           status: AuthStatus.authenticated,
//           userId: userCredential.user!.uid,
//           userName: userDoc['name'],
//         ));
//       } else {
//         // Handle case where user document doesn't exist
//         emit(state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: "User profile not found.",
//         ));
//       }
//     } on FirebaseAuthException catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage:
//             e.message ?? "Login failed. Please check your credentials.",
//       ));
//     }
//   }

//   Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
//     try {
//       // Clear any stored login credentials
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('is_logged_in');
//       await prefs.remove('user_email');
//       await prefs.remove('user_password');

//       // Sign out from Firebase
//       await _firebaseAuth.signOut();

//       // Emit unauthenticated state
//       emit(const AuthState(status: AuthStatus.unauthenticated));
//     } catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: 'Logout failed',
//       ));
//     }
//   }
// }
 // enum AuthStatus {
//   initial,
//   loading,
//   authenticated,
//   unauthenticated,
//   error,
//   blocked
// }

// class AuthState {
//   final AuthStatus status;
//   final String? userId;
//   final String? userName;
//   final String? errorMessage;
//   final bool isGoogleSignIn;
//   final bool isEmailSignIn; // New field to track email sign-in

//   const AuthState({
//     this.status = AuthStatus.unauthenticated,
//     this.userId,
//     this.userName,
//     this.errorMessage,
//     this.isGoogleSignIn = false,
//     this.isEmailSignIn = false, // Default to false
//   });

//   AuthState copyWith({
//     AuthStatus? status,
//     String? userId,
//     String? userName,
//     String? errorMessage,
//     bool? isGoogleSignIn,
//     bool? isEmailSignIn,
//   }) {
//     return AuthState(
//       status: status ?? this.status,
//       userId: userId ?? this.userId,
//       userName: userName ?? this.userName,
//       errorMessage: errorMessage ?? this.errorMessage,
//       isGoogleSignIn: isGoogleSignIn ?? this.isGoogleSignIn,
//       isEmailSignIn:
//           isEmailSignIn ?? this.isEmailSignIn, // Handle this in copyWith
//     );
//   }
// }
//import 'authentication_event.dart';

// class AuthState {
//   final bool isLoading;
//   final bool isAuthenticated;
//   final String? userId;

//   const AuthState({
//     this.isLoading = false,
//     this.isAuthenticated = false,
//     this.userId,
//   });

//   // Quick factory constructors
//   factory AuthState.initial() => AuthState();
//   factory AuthState.loading() => AuthState(isLoading: true);
//   factory AuthState.authenticated(String userId) => 
//       AuthState(isAuthenticated: true, userId: userId);
//   factory AuthState.unauthenticated() => AuthState(isAuthenticated: false);
// }


// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vesture_firebase_user/bloc/authentication/authentication_event.dart';
// import 'package:vesture_firebase_user/bloc/authentication/authentication_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final FirebaseAuth _firebaseAuth;
//   final FirebaseFirestore _firestore;
//   final GoogleSignIn _googleSignIn;

//   AuthBloc({
//     required FirebaseAuth firebaseAuth,
//     required FirebaseFirestore firestore,
//     GoogleSignIn? googleSignIn,
//   })  : _firebaseAuth = firebaseAuth,
//         _firestore = firestore,
//         _googleSignIn = googleSignIn ?? GoogleSignIn(),
//         super(const AuthState()) {
//     on<SignUpRequested>(_onSignUp);
//     on<LoginRequested>(_onLogin);
//     on<LogoutRequested>(_onLogout);
//     on<AuthCheckRequested>(_onAuthCheck);
//     on<GoogleSignInRequested>(_onGoogleSignIn);

//     add(AuthCheckRequested());
//   }
//   Future<void> _onGoogleSignIn(
//       GoogleSignInRequested event, Emitter<AuthState> emit) async {
//     emit(state.copyWith(status: AuthStatus.loading));
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         emit(state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: "Google Sign-In canceled.",
//         ));
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       DocumentSnapshot userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       if (userDoc.exists) {
//         var userData = userDoc.data() as Map<String, dynamic>;

//         // Check if the user is blocked
//         bool isBlocked = userData['isBlocked'] ?? false;
//         if (isBlocked) {
//           emit(state.copyWith(
//             status: AuthStatus.error,
//             errorMessage:
//                 "Your account has been blocked. Please contact support.",
//           ));
//           return;
//         }

//         // Add default fields if missing
//         if (!userData.containsKey('imageUrl')) {
//           await _firestore
//               .collection('users')
//               .doc(userCredential.user!.uid)
//               .update({
//             'imageUrl': '', // Or a placeholder image URL
//           });
//         }
//         if (!userData.containsKey('isBlocked')) {
//           await _firestore
//               .collection('users')
//               .doc(userCredential.user!.uid)
//               .update({
//             'isBlocked': false,
//           });
//         }

//         emit(state.copyWith(
//           status: AuthStatus.authenticated,
//           userId: userCredential.user!.uid,
//           userName: userDoc['name'],
//         ));
//       } else {
//         // Create a new user document with default values
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'name': googleUser.displayName,
//           'email': googleUser.email,
//           'createdAt': FieldValue.serverTimestamp(),
//           'imageUrl': '', // Default image URL
//           'isBlocked': false, // Default blocked status
//         });

//         emit(state.copyWith(
//           status: AuthStatus.authenticated,
//           userId: userCredential.user!.uid,
//           userName: googleUser.displayName,
//         ));
//       }
//     } catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: e.toString(),
//       ));
//     }
//   }

//   Future<void> _onAuthCheck(
//       AuthCheckRequested event, Emitter<AuthState> emit) async {
//     try {
//       final user = _firebaseAuth.currentUser;
//       if (user != null) {
//         // Fetch user details from Firestore
//         final userDoc =
//             await _firestore.collection('users').doc(user.uid).get();

//         // Check if the user is blocked
//         var userData = userDoc.data() as Map<String, dynamic>?;
//         bool isBlocked = userData?['isBlocked'] ?? false;

//         if (isBlocked) {
//           // If user is blocked, log out
//           await _firebaseAuth.signOut();
//           emit(state.copyWith(status: AuthStatus.unauthenticated));
//         } else {
//           emit(state.copyWith(
//             status: AuthStatus.authenticated,
//             userId: user.uid,
//             userName: userDoc.exists ? userDoc['name'] : null,
//           ));
//         }
//       } else {
//         emit(state.copyWith(status: AuthStatus.unauthenticated));
//       }
//     } catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.unauthenticated,
//         errorMessage: 'Authentication check failed',
//       ));
//     }
//   }

//   Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
//     if (event.name.isEmpty) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: "Name cannot be empty.",
//       ));
//       return;
//     }
//     if (event.email.isEmpty ||
//         !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
//             .hasMatch(event.email)) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: "Please enter a valid email.",
//       ));
//       return;
//     }
//     if (event.password.isEmpty || event.password.length < 6) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: "Password must be at least 6 characters long.",
//       ));
//       return;
//     }

//     emit(state.copyWith(status: AuthStatus.loading));
//     try {
//       UserCredential userCredential =
//           await _firebaseAuth.createUserWithEmailAndPassword(
//         email: event.email,
//         password: event.password,
//       );

//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'name': event.name,
//         'email': event.email,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       emit(state.copyWith(
//         status: AuthStatus.authenticated,
//         userId: userCredential.user!.uid,
//         userName: event.name,
//       ));
//     } on FirebaseAuthException catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: e.message ?? "Signup failed. Please try again.",
//       ));
//     }
//   }

//   Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
//     emit(state.copyWith(status: AuthStatus.loading));
//     try {
//       UserCredential userCredential =
//           await _firebaseAuth.signInWithEmailAndPassword(
//         email: event.email,
//         password: event.password,
//       );

//       // Store login credentials
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('is_logged_in', true);
//       await prefs.setString('user_email', event.email);
//       await prefs.setString('user_password', event.password);

//       DocumentSnapshot userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       // Check if the document exists and cast the data to Map<String, dynamic>
//       if (userDoc.exists) {
//         var userData = userDoc.data() as Map<String, dynamic>;

//         // Check if the user is blocked
//         bool isBlocked = userData['isBlocked'] ?? false;
//         if (isBlocked) {
//           // User is blocked, prevent login
//           emit(state.copyWith(
//             status: AuthStatus.error,
//             errorMessage:
//                 "Your account has been blocked. Please contact support.",
//           ));
//           return;
//         }

//         // If imageUrl doesn't exist, update the Firestore document with a default value
//         if (!userData.containsKey('imageUrl')) {
//           await _firestore
//               .collection('users')
//               .doc(userCredential.user!.uid)
//               .update({
//             'imageUrl': '', // Or you can use a placeholder image URL here
//           });
//         }

//         // If isBlocked field doesn't exist, add it with default value false
//         if (!userData.containsKey('isBlocked')) {
//           await _firestore
//               .collection('users')
//               .doc(userCredential.user!.uid)
//               .update({
//             'isBlocked': false,
//           });
//         }

//         // Emit the state with the user information from Firestore
//         emit(state.copyWith(
//           status: AuthStatus.authenticated,
//           userId: userCredential.user!.uid,
//           userName: userDoc['name'],
//         ));
//       } else {
//         // Handle case where user document doesn't exist
//         emit(state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: "User profile not found.",
//         ));
//       }
//     } on FirebaseAuthException catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage:
//             e.message ?? "Login failed. Please check your credentials.",
//       ));
//     }
//   }

//   Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
//     try {
//       // Clear any stored login credentials
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('is_logged_in');
//       await prefs.remove('user_email');
//       await prefs.remove('user_password');

//       // Sign out from Firebase
//       await _firebaseAuth.signOut();

//       // Emit unauthenticated state
//       emit(const AuthState(status: AuthStatus.unauthenticated));
//     } catch (e) {
//       emit(state.copyWith(
//         status: AuthStatus.error,
//         errorMessage: 'Logout failed',
//       ));
//     }
//   }
// }
