import 'package:cloud_firestore/cloud_firestore.dart';

class AddressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAddress(
      String userId, Map<String, dynamic> addressData) async {
    if (userId.isEmpty) {
      throw Exception('Invalid user ID');
    }

    final data = {
      ...addressData,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .add(data);
  }

  Future<List<Map<String, dynamic>>> loadAddresses(String userId) async {
    if (userId.isEmpty) {
      throw Exception('Invalid user ID');
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .where('userId', isEqualTo: userId)
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
    if (userId.isEmpty || addressId.isEmpty) {
      throw Exception('Invalid user ID or address ID');
    }

    final data = {
      ...addressData,
      'userId': userId,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId);

    final doc = await docRef.get();
    if (!doc.exists || doc.data()?['userId'] != userId) {
      throw Exception('Address not found or unauthorized');
    }

    await docRef.update(data);
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    if (userId.isEmpty || addressId.isEmpty) {
      throw Exception('Invalid user ID or address ID');
    }

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId);

    final doc = await docRef.get();
    if (!doc.exists || doc.data()?['userId'] != userId) {
      throw Exception('Address not found or unauthorized');
    }

    await docRef.delete();
  }
}
