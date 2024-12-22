import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_bloc.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_state.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

Widget favoriteSearchField(BuildContext context) {
  final searchController = TextEditingController();

  return BlocBuilder<FavoriteBloc, FavoriteState>(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search in Favorites',
            hintStyle:
                styling(fontFamily: 'Poppins-Regular', color: Colors.grey),
            suffixIcon: IconButton(
              icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 15),
              onPressed: () {
                if (state is FavoritesLoadedState) {
                  context.read<FavoriteBloc>().add(
                        SearchFavoritesEvent(
                          query: searchController.text,
                          products: (state).products,
                        ),
                      );
                }
              },
            ),
            border: const OutlineInputBorder(),
          ),
          onChanged: (query) {
            if (state is FavoritesLoadedState) {
              context.read<FavoriteBloc>().add(
                    SearchFavoritesEvent(
                      query: query,
                      products: (state).products,
                    ),
                  );
            }
          },
        ),
      );
    },
  );
}
