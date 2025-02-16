import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_bloc.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/coupon/bloc/coupon_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/userprofile_bloc.dart';
import 'package:vesture_firebase_user/bloc/cubit/theme_cubit.dart';
import 'package:vesture_firebase_user/bloc/cubit/theme_state.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_bloc.dart';
import 'package:vesture_firebase_user/bloc/home/bloc/home_bloc.dart';
import 'package:vesture_firebase_user/bloc/home/bloc/home_event.dart';
import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_bloc.dart';
import 'package:vesture_firebase_user/bloc/review/bloc/review_bloc.dart';
import 'package:vesture_firebase_user/bloc/wallet/bloc/wallet_bloc.dart';
import 'package:vesture_firebase_user/firebase_options.dart';
import 'package:vesture_firebase_user/repository/address_repo.dart';
import 'package:vesture_firebase_user/repository/cart_repo.dart';
import 'package:vesture_firebase_user/repository/category_repo.dart';
import 'package:vesture_firebase_user/repository/checkout_repo.dart';
import 'package:vesture_firebase_user/repository/coupon_repo.dart';
import 'package:vesture_firebase_user/repository/fav_repository.dart';
import 'package:vesture_firebase_user/repository/home_repo.dart';
import 'package:vesture_firebase_user/repository/orders_repo.dart';
import 'package:vesture_firebase_user/repository/product_repo.dart';
import 'package:vesture_firebase_user/repository/review_repo.dart';
import 'package:vesture_firebase_user/repository/wallet_repo.dart';
import 'package:vesture_firebase_user/screens/splash_screen.dart';
import 'package:vesture_firebase_user/themes/theme.dart';
import 'package:vesture_firebase_user/utilities&Services/keysApi.dart';
import 'package:vesture_firebase_user/utilities&Services/nav_service.dart';

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
          navigatorKey: navigatorKey,
          title: 'Vesture',
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: themeData,
          darkTheme: darkmode,
          themeMode:
              state is LightThemeState ? ThemeMode.light : ThemeMode.dark,
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final String? userId = currentUser?.uid;

  final homeRepository = HomeRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CheckoutBloc>(
          create: (context) => CheckoutBloc(
            cartBloc: context.read<CartBloc>(),
            couponBloc: context.read<CouponBloc>(),
            checkoutRepository: CheckoutRepository(),
          ),
        ),
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
        BlocProvider(
          create: (_) => ProductDetailsBloc(cartRepository: CartRepository()),
        ),
        BlocProvider(
          create: (_) => FavoriteBloc(favoriteRepository: FavoriteRepository()),
        ),
        BlocProvider(
          create: (_) => CategoryBloc(categoryRepository: CategoryRepository()),
        ),
        BlocProvider(
          create: (_) => CartBloc(cartRepository: CartRepository()),
        ),
        BlocProvider(create: (_) => AddressBloc(userId!, AddressRepository())),
        BlocProvider<WalletBloc>(
          create: (_) => WalletBloc(walletRepository: WalletRepository()),
        ),
        BlocProvider<OrdersBloc>(
          create: (context) => OrdersBloc(
            OrdersRepository(),
            context.read<WalletBloc>(),
          ),
        ),
        BlocProvider<ReviewBloc>(
          create: (context) => ReviewBloc(
            reviewRepository: ReviewRepository(),
          ),
        ),
        BlocProvider<CouponBloc>(
          create: (context) => CouponBloc(
            couponRepository: CouponRepository(),
          ),
        ),
        BlocProvider<HomeBloc>(
          create: (_) =>
              HomeBloc(repository: homeRepository)..add(LoadHomeData()),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(
            productRepository: ProductRepository(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}
