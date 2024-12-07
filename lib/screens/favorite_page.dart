// favorites_page.dart

import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'Favorites'),
      body: Center(child: Text('Favorites Page')),
    );
  }
}
