// profile_list_tile.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Future<int>
      futureData; // Any future data (e.g., address count, order count)
  final VoidCallback onTap;

  const ProfileListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.futureData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text(
              title,
              style: styling(),
            ),
            subtitle: Text(
              'Loading...',
              style: styling(),
            ),
            onTap: onTap,
          );
        }

        if (snapshot.hasError) {
          return ListTile(
            title: Text(
              title,
              style: styling(),
            ),
            subtitle: Text(
              'Error loading data',
              style: styling(),
            ),
            onTap: onTap,
          );
        }

        final int dataCount = snapshot.data ?? 0;

        return ListTile(
          title: Text(
            title,
            style: styling(),
          ),
          subtitle: Text(
            '$subtitle $dataCount',
            style: styling(color: Colors.grey),
          ),
          onTap: onTap,
        );
      },
    );
  }
}
