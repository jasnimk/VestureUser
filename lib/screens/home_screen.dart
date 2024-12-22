import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vesture_firebase_user/screens/list_categories.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> imageData = [
    {
      'image': 'assets/Images/kids2.jpg',
      'text': 'Kids Collection',
    },
    {
      'image': 'assets/Images/men1.jpg',
      'text': 'Men Fashion',
    },
    {
      'image': 'assets/Images/women7.jpg',
      'text': 'Women Wear',
    },
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CarouselSlider(
                  items: imageData.map((data) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Image.asset(
                          data['image']!,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.4,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    scrollPhysics: const BouncingScrollPhysics(),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageData.map((data) {
                      int index = imageData.indexOf(data);
                      return Container(
                        width: _currentIndex == index ? 20 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.red
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShopCategories()),
                      );
                    },
                    child: Image.asset(
                      'assets/Images/women1.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ShopCategories()),
                              );
                            },
                            child: Image.asset(
                              'assets/Images/men2.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                              top: 140,
                              left: 20,
                              child: Text(
                                "Men's",
                                style: styling(
                                    fontFamily: 'Poppins-Bold',
                                    fontSize: 40,
                                    color: Colors.white),
                              ))
                        ]),
                      ),
                      Expanded(
                        flex: 1,
                        child: Stack(children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ShopCategories()),
                              );
                            },
                            child: Image.asset(
                              'assets/Images/men3.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                              top: 100,
                              left: 35,
                              right: 0,
                              child: Text(
                                "Trendy Black",
                                style: styling(
                                    fontFamily: 'Poppins-Bold',
                                    fontSize: 40,
                                    color: Colors.white),
                              ))
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
