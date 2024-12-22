import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_bloc.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_state.dart';
import 'package:vesture_firebase_user/repository/fav_repository.dart';
import 'package:vesture_firebase_user/screens/product_Details.dart';
import 'package:vesture_firebase_user/screens/shopping_page.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';
import 'package:vesture_firebase_user/widgets/fab.dart';
import 'package:vesture_firebase_user/widgets/favorite_widgets.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FavoriteBloc(favoriteRepository: FavoriteRepository())
            ..add(FetchFavoritesEvent()),
      child: Scaffold(
        appBar: buildCustomAppBar(
          context: context,
          title: 'My Favorites',
          showBackButton: true,
        ),
        body: Column(
          children: [
            favoriteSearchField(context),
            BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                if (state is FavoriteLoadingState) {
                  return Expanded(
                      child: buildLoadingIndicator(context: context));
                }

                if (state is FavoriteErrorState) {
                  return Expanded(child: buildErrorWidget(state.errorMessage));
                }

                if (state is FavoritesLoadedState) {
                  if (state.products.isEmpty) {
                    return Expanded(
                        child: buildEmptyStateWidget(
                            message: 'No favorite products found!',
                            subMessage: 'Start adding some favorites'));
                  }

                  return Expanded(
                      child: buildProductGridView(
                          products: state.products,
                          context: context,
                          onItemTap: (product) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(
                                        productId: product.id!)));
                            return null;
                          }));
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoritesLoadedState && state.products.isEmpty) {
              return BubblingFAB(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const ShoppingPage()));
                },
                icon: Icons.shop,
                backgroundColor: const Color.fromRGBO(196, 28, 13, 0.829),
                iconColor: Colors.white,
                scaleStart: 1.0,
                scaleEnd: 1.1,
                duration: const Duration(milliseconds: 1500),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
