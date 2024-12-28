// profile_utils.dart

import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getAddressCount(String userId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();

    return snapshot.docs.length;
  } catch (e) {
    return 0;
  }
}

Future<int> getOrdersCount(String userId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.length;
  } catch (e) {
    return 0;
  }
}
