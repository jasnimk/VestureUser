import 'package:cloud_firestore/cloud_firestore.dart';

class AddressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAddress(
      String userId, Map<String, dynamic> addressData) async {
    final data = {
      ...addressData,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .add(data);
  }

  Future<List<Map<String, dynamic>>> loadAddresses(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();
  }

  Future<void> updateAddress(
      String userId, String addressId, Map<String, dynamic> addressData) async {
    final data = {
      ...addressData,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .update(data);
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }
}
