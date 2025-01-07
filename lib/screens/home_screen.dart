// //homescreen
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:vesture_firebase_user/bloc/home/bloc/home_bloc.dart';
// import 'package:vesture_firebase_user/bloc/home/bloc/home_event.dart';
// import 'package:vesture_firebase_user/bloc/home/bloc/home_state.dart';
// import 'package:vesture_firebase_user/models/brand_model.dart';
// import 'package:vesture_firebase_user/screens/cart_page.dart';
// import 'package:vesture_firebase_user/screens/categories_shop.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return HomeView();
//   }
// }

// class HomeView extends StatelessWidget {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             context.read<HomeBloc>().add(RefreshHomeData());
//           },
//           child: BlocBuilder<HomeBloc, HomeState>(
//             builder: (context, state) {
//               if (state is HomeLoading) {
//                 return _buildLoadingShimmer();
//               }

//               if (state is HomeError) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, size: 48, color: Colors.red),
//                       SizedBox(height: 16),
//                       Text(state.message),
//                       ElevatedButton(
//                         onPressed: () {
//                           context.read<HomeBloc>().add(LoadHomeData());
//                         },
//                         child: Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               if (state is HomeLoaded) {
//                 return CustomScrollView(
//                   slivers: [
//                     _buildAppBar(context),
//                     SliverToBoxAdapter(
//                       child: _buildOffersCarousel(state),
//                     ),
//                     SliverToBoxAdapter(
//                       child: _buildBrandsSection(state),
//                     ),
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Text(
//                           'Categories',
//                           style: headerStyling(),
//                         ).animate().fadeIn().slideX(),
//                       ),
//                     ),
//                     _buildCategoriesGrid(state),
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Text(
//                           'Available Coupons',
//                           style: Theme.of(context).textTheme.headlineLarge,
//                         ).animate().fadeIn().slideX(),
//                       ),
//                     ),
//                     _buildCouponsGrid(state),
//                   ],
//                 );
//               }

//               return SizedBox();
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 200,
//               margin: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.all(16),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.8,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemCount: 4,
//               itemBuilder: (context, index) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOffersCarousel(HomeLoaded state) {
//     return CarouselSlider.builder(
//       itemCount: state.activeOffers.length,
//       options: CarouselOptions(
//         height: 200,
//         autoPlay: true,
//         enlargeCenterPage: true,
//         viewportFraction: .9,
//         autoPlayAnimationDuration: Duration(milliseconds: 800),
//         autoPlayCurve: Curves.fastOutSlowIn,
//       ),
//       itemBuilder: (context, index, realIndex) {
//         final offer = state.activeOffers[index];
//         final product = offer.id != null ? state.offerProducts[offer.id] : null;

//         return GestureDetector(
//           onTap: () {
//             if (offer.parentCategoryId != null) {
//               // Check if categoryId exists
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (ctx) => CategoryProductDetailsScreen(
//                     categoryId:
//                         offer.parentCategoryId!, // Use offer's categoryId
//                   ),
//                 ),
//               );
//             }
//           },
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: 8), // Adjusted margin
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   product?.getDefaultImages().isNotEmpty == true
//                       ? Image.memory(
//                           base64Decode(product!.getDefaultImages().first),
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             print('Error loading image: $error');
//                             return Container(color: Colors.grey);
//                           },
//                         )
//                       : Container(color: Colors.grey),
//                   Positioned(
//                     bottom: 16,
//                     left: 10,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               color: const Color.fromARGB(255, 121, 10, 10),
//                               border: Border.all()),
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8.0, right: 8),
//                             child: Padding(
//                               padding: const EdgeInsets.all(4.0),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     'SAVE ${offer.discount.toStringAsFixed(0)}%',
//                                     style: styling(
//                                       color: Colors.white,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     'Shop Before ${_formatDate(offer.validTo)}',
//                                     style: styling(
//                                       color: Colors.white,
//                                       fontSize: 8,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ).animate().fade().scale(),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCategoriesGrid(HomeLoaded state) {
//     return SliverPadding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       sliver: SliverGrid(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 1,
//           childAspectRatio: 0.8,
//           crossAxisSpacing: 2,
//           mainAxisSpacing: 1,
//         ),
//         delegate: SliverChildBuilderDelegate(
//           (context, index) {
//             final category = state.categories[index];
//             final product = category.id != null
//                 ? state.categoryProducts[category.id]
//                 : null;

//             return AnimationConfiguration.staggeredGrid(
//               position: index,
//               columnCount: 2,
//               duration: Duration(milliseconds: 500),
//               child: SlideAnimation(
//                 verticalOffset: 50.0,
//                 child: FadeInAnimation(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (ctx) => CategoryProductDetailsScreen(
//                             categoryId: category.id!,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: product?.getDefaultImages().isNotEmpty ==
//                                     true
//                                 ? Image.memory(
//                                     base64Decode(
//                                         product!.getDefaultImages().first),
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       print('Error loading image: $error');
//                                       return Container(color: Colors.grey);
//                                     },
//                                   )
//                                 : Container(color: Colors.grey),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(2),
//                               gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Colors.transparent,
//                                   const Color.fromARGB(255, 142, 11, 2)
//                                       .withValues(red: -12)
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 16,
//                             left: 16,
//                             right: 16,
//                             child: Text(
//                               category.name ?? '',
//                               style: headerStyling(
//                                   color: Colors.white, fontSize: 25),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//           childCount: state.categories.length,
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       floating: true,
//       title: Text('Fashion Store'),
//       centerTitle: false,
//       actions: [
//         IconButton(
//           icon: Icon(Icons.shopping_cart),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CartScreen()),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }

//   Widget _buildBrandsSection(HomeLoaded state) {
//     if (state.brands.isEmpty) {
//       print('No brands available in state'); // Debug log
//       return SizedBox.shrink();
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: Text(
//             'Top Brands',
//             style: headerStyling(),
//           ).animate().fadeIn().slideX(),
//         ),
//         Container(
//           height: 120,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             itemCount: state.brands.length,
//             itemBuilder: (context, index) {
//               final brand = state.brands[index];
//               print(
//                   'Building brand: ${brand.brandName} - Has icon: ${brand.brandIcon != null}'); // Debug log

//               return AnimationConfiguration.staggeredList(
//                 position: index,
//                 duration: Duration(milliseconds: 500),
//                 child: SlideAnimation(
//                   horizontalOffset: 50.0,
//                   child: FadeInAnimation(
//                     child: Container(
//                       width: 100,
//                       margin: EdgeInsets.only(right: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 4,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _buildBrandIcon(brand),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 4),
//                             child: Text(
//                               brand.brandName, // Changed from name to brandName
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBrandIcon(BrandModel brand) {
//     if (brand.brandIcon == null || brand.brandIcon!.isEmpty) {
//       return Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(Icons.business, size: 30, color: Colors.grey[400]),
//       );
//     }

//     try {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: Image.memory(
//           base64Decode(brand.brandIcon!),
//           width: 60,
//           height: 60,
//           fit: BoxFit.contain,
//           errorBuilder: (context, error, stackTrace) {
//             print(
//                 'Error loading brand image for ${brand.brandName}: $error'); // Changed from name to brandName
//             return Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child:
//                   Icon(Icons.error_outline, size: 30, color: Colors.grey[400]),
//             );
//           },
//         ),
//       );
//     } catch (e) {
//       print(
//           'Exception while decoding brand image for ${brand.brandName}: $e'); // Changed from name to brandName
//       return Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(Icons.warning, size: 30, color: Colors.grey[400]),
//       );
//     }
//   }

//   Widget _buildCouponsGrid(HomeLoaded state) {
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.8,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//       ),
//       delegate: SliverChildBuilderDelegate(
//         (context, index) {
//           final coupon = state.activeCoupons[index];
//           final categories = state.couponCategories[coupon.id] ?? [];

//           return AnimationConfiguration.staggeredGrid(
//             position: index,
//             columnCount: 2,
//             duration: Duration(milliseconds: 500),
//             child: SlideAnimation(
//               verticalOffset: 50.0,
//               child: FadeInAnimation(
//                 child: Card(
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: GridView.builder(
//                           padding: EdgeInsets.all(8),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio: 1,
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 8,
//                           ),
//                           itemCount: categories.length.clamp(0, 4),
//                           itemBuilder: (context, catIndex) {
//                             final category = categories[catIndex];
//                             final images = state.couponCategoryImages[coupon.id]
//                                 ?[category.id];
//                             final firstImage = images?.isNotEmpty == true
//                                 ? images!.first
//                                 : null;

//                             return ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: firstImage != null
//                                   ? Image.memory(
//                                       base64Decode(firstImage),
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                         print(
//                                             'Error loading coupon category image: $error');
//                                         return Container(
//                                             color: Colors.grey[300]);
//                                       },
//                                     )
//                                   : Container(color: Colors.grey[300]),
//                             );
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${coupon.discount}% OFF',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     coupon.couponCode,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       letterSpacing: 1,
//                                     ),
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.copy, size: 20),
//                                   onPressed: () {
//                                     Clipboard.setData(
//                                         ClipboardData(text: coupon.couponCode));
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('Coupon code copied!'),
//                                         behavior: SnackBarBehavior.floating,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//         childCount: state.activeCoupons.length,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vesture_firebase_user/bloc/home/bloc/home_bloc.dart';
import 'package:vesture_firebase_user/bloc/home/bloc/home_event.dart';
import 'package:vesture_firebase_user/bloc/home/bloc/home_state.dart';
import 'package:vesture_firebase_user/widgets/home_screen_widgets.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(RefreshHomeData());
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return _buildLoadingShimmer();
              }

              if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(LoadHomeData());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is HomeLoaded) {
                return CustomScrollView(
                  slivers: [
                    HomeScreenWidgets.buildAppBar(context),
                    SliverToBoxAdapter(
                      child: HomeScreenWidgets.buildOffersCarousel(state),
                    ),
                    SliverToBoxAdapter(
                      child: HomeScreenWidgets.buildBrandsSection(state),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Categories',
                          style: headerStyling(),
                        ).animate().fadeIn().slideX(),
                      ),
                    ),
                    HomeScreenWidgets.buildCategoriesGrid(state),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Available Coupons',
                          style: headerStyling(),
                        ).animate().fadeIn().slideX(),
                      ),
                    ),
                    HomeScreenWidgets.buildCouponsGrid(state),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
