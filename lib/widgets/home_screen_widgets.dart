import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vesture_firebase_user/bloc/home/bloc/home_state.dart';
import 'package:vesture_firebase_user/models/brand_model.dart';
import 'package:vesture_firebase_user/screens/cart_page.dart';
import 'package:vesture_firebase_user/screens/categories_shop.dart';
import 'package:vesture_firebase_user/widgets/custom_snackbar.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class HomeScreenWidgets {
  static Widget buildOffersCarousel(HomeLoaded state) {
    return CarouselSlider.builder(
      itemCount: state.activeOffers.length,
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: .9,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      itemBuilder: (context, index, realIndex) {
        final offer = state.activeOffers[index];
        final product = offer.id != null ? state.offerProducts[offer.id] : null;

        return GestureDetector(
          onTap: () {
            if (offer.parentCategoryId != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => CategoryProductDetailsScreen(
                    categoryId: offer.parentCategoryId!,
                  ),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  product?.getDefaultImages().isNotEmpty == true
                      ? Image.memory(
                          base64Decode(product!.getDefaultImages().first),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Container(color: Colors.grey);
                          },
                        )
                      : Container(color: Colors.grey),
                  Positioned(
                    bottom: 16,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 121, 10, 10)
                                .withOpacity(0.8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 14.0, right: 14.0, top: 5, bottom: 5),
                            child: Column(
                              children: [
                                Text(
                                  'SAVE ${offer.discount.toStringAsFixed(0)}%',
                                  style: styling(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Shop Before ${_formatDate(offer.validTo)}',
                                  style: styling(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade().scale(),
        );
      },
    );
  }

  static Widget buildCategoriesGrid(HomeLoaded state) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 0.8,
          crossAxisSpacing: 2,
          mainAxisSpacing: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = state.categories[index];
            final product = category.id != null
                ? state.categoryProducts[category.id]
                : null;

            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 2,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => CategoryProductDetailsScreen(
                            categoryId: category.id!,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: product?.getDefaultImages().isNotEmpty ==
                                    true
                                ? Image.memory(
                                    base64Decode(
                                        product!.getDefaultImages().first),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(color: Colors.grey);
                                    },
                                  )
                                : Container(color: Colors.grey),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  const Color.fromARGB(255, 142, 11, 2)
                                      .withValues(red: -12)
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Text(
                              category.name ?? '',
                              style: headerStyling(
                                  color: Colors.white, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: state.categories.length,
        ),
      ),
    );
  }

  static Widget buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      title: const Text('Fashion Store'),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
        ),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static Widget buildBrandsSection(HomeLoaded state) {
    if (state.brands.isEmpty) {
      print('No brands available in state');
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Top Brands',
            style: headerStyling(),
          ).animate().fadeIn().slideX(),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.brands.length,
            itemBuilder: (context, index) {
              final brand = state.brands[index];
              return _buildBrandItem(brand, index);
            },
          ),
        ),
      ],
    );
  }

  static Widget _buildBrandItem(BrandModel brand, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            width: 100,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBrandIcon(brand),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    brand.brandName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildBrandIcon(BrandModel brand) {
    if (brand.brandIcon == null || brand.brandIcon!.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.business, size: 30, color: Colors.grey[400]),
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          base64Decode(brand.brandIcon!),
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading brand image for ${brand.brandName}');
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  Icon(Icons.error_outline, size: 30, color: Colors.grey[400]),
            );
          },
        ),
      );
    } catch (e) {
      print('Exception while decoding brand image for ${brand.brandName}: $e');
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.warning, size: 30, color: Colors.grey[400]),
      );
    }
  }

  static Widget buildCouponsGrid(HomeLoaded state) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final coupon = state.activeCoupons[index];
          final categories = state.couponCategories[coupon.id] ?? [];
          final categoryImages = state.couponCategoryImages[coupon.id] ?? {};

          // Get the first category and its image
          final firstCategory = categories.isNotEmpty ? categories.first : null;
          final firstImage = firstCategory != null
              ? categoryImages[firstCategory.id]?.firstOrNull
              : null;

          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Image layer
                        Positioned.fill(
                          child: firstImage != null
                              ? Image.memory(
                                  base64Decode(firstImage),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(color: Colors.grey[300]);
                                  },
                                )
                              : Container(color: Colors.grey[300]),
                        ),

                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(1),
                                ],
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Text content
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(255, 121, 10, 10)
                                    .withOpacity(0.7)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, bottom: 8, left: 12, right: 12),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${coupon.discount}% OFF',
                                        style: headerStyling(
                                          fontSize: 8,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        coupon.couponCode,
                                        style: styling(
                                            color: Colors.white,
                                            letterSpacing: 1,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                          text: coupon.couponCode,
                                        ));
                                        CustomSnackBar.show(context,
                                            message: 'Coupon code copied!');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Icon(
                                          Icons.copy,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: state.activeCoupons.length,
      ),
    );
  }
}
