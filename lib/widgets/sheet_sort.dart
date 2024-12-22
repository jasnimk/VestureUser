import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

void showSortBottomSheet(
    BuildContext context, Function(String) onSortSelected) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: headerStyling(fontFamily: 'Poppins-SemiBold'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                'Price: Lowest to High',
                style: styling(),
              ),
              onTap: () {
                onSortSelected('Price: lowest to high');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Price: Highest to low',
                style: styling(),
              ),
              onTap: () {
                onSortSelected('Price: highest to low');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Customer Review',
                style: styling(),
              ),
              onTap: () {
                onSortSelected('Rating: highest first');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

customFilterSortRow({
  required BuildContext context,
  required VoidCallback onFilterPressed,
  required VoidCallback onSortPressed,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    child: Card(
      shape: BeveledRectangleBorder(),
      shadowColor: Color.fromRGBO(196, 28, 13, 0.829),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customElevatedButton(
            icon: Icons.filter_list,
            label: "Filters",
            onPressed: onFilterPressed,
          ),
          customElevatedButton(
            icon: Icons.sort,
            label: "Sort By",
            onPressed: onSortPressed,
          ),
        ],
      ),
    ),
  );
}
