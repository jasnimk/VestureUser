import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/screens/cart_page.dart';
import 'package:vesture_firebase_user/screens/favorite_page.dart';
import 'package:vesture_firebase_user/screens/home_screen.dart';
import 'package:vesture_firebase_user/screens/list_categories.dart';
import 'package:vesture_firebase_user/screens/profile_page.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen({super.key, required this.userId});

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
        type: BottomNavigationBarType.shifting,
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
        items: [
          BottomNavigationBarItem(
            icon: _buildCustomIcon(FontAwesomeIcons.house, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildCustomIcon(FontAwesomeIcons.cartShopping, 1),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: _buildCustomIcon(FontAwesomeIcons.bagShopping, 2),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: _buildCustomIcon(FontAwesomeIcons.heart, 3),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: _buildCustomIcon(FontAwesomeIcons.user, 4),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomIcon(IconData iconData, int index) {
    bool isSelected = _currentIndex == index;

    double scale = isSelected ? 1.2 : 1.0;
    Color iconColor = isSelected ? Colors.white : Colors.black;
    Color containerColor =
        isSelected ? Color.fromRGBO(196, 28, 13, 0.829) : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: scale,
        child: Icon(
          iconData,
          size: 12,
          color: iconColor,
        ),
      ),
    );
  }
}
