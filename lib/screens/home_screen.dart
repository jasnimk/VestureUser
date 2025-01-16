import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vesture_firebase_user/bloc/home/bloc/home_bloc.dart';
import 'package:vesture_firebase_user/bloc/home/bloc/home_event.dart';
import 'package:vesture_firebase_user/bloc/home/bloc/home_state.dart';
import 'package:vesture_firebase_user/widgets/home_screen_widgets.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

/// HomeScreen widget that serves as the entry point for the Home view
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

/// HomeView widget that builds the layout for the home screen, including
/// handling loading, error, and data-loaded states with dynamic content
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
            // Builds UI based on HomeBloc state
            builder: (context, state) {
              if (state is HomeLoading) {
                return _buildLoadingShimmer(); // Show shimmer effect when loading
              }

              if (state is HomeError) {
                return Center(
                  // Display error message with retry option
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
                  // Display content when data is loaded
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

  /// Builds a shimmer effect to indicate loading state
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
