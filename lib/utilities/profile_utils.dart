// profile_utils.dart

import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getAddressCount(String userId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();

    return snapshot.docs.length; // Return the number of addresses
  } catch (e) {
    print('Error fetching addresses: $e');
    return 0; // Return 0 if there's an error
  }
}

// Add similar functions here for other data if needed in future
// For example, to fetch order count, payment methods, etc.
