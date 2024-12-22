import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/screens/cart_page.dart';
import 'package:vesture_firebase_user/screens/favorite_page.dart';
import 'package:vesture_firebase_user/screens/home_screen.dart';
import 'package:vesture_firebase_user/screens/list_categories.dart';
import 'package:vesture_firebase_user/screens/profile_page.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    print("User ID: $userId");
  }

  int _currentIndex = 0;

  late final List<Widget> _pages = [
    HomeScreen(),
    const ShopCategories(),
    CartScreen(),
    const FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        selectedIconTheme: const IconThemeData(size: 28),
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedIconTheme: const IconThemeData(size: 18),
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.cartShopping),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.bagShopping),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.heart),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
