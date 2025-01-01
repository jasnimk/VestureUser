import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/wallet_model.dart';
import 'package:vesture_firebase_user/repository/wallet_repo.dart';
import 'package:vesture_firebase_user/screens/address_page.dart';
import 'package:vesture_firebase_user/screens/orders_page.dart';
import 'package:vesture_firebase_user/screens/wallet_screen.dart';
import 'package:vesture_firebase_user/screens/settings_page.dart';
import 'package:vesture_firebase_user/utilities/profile_utils.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final walletRepo = WalletRepository();

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    walletRepo.getWallet().listen((wallet) {
      print('Current balance: ${wallet.balance}');
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Card(
                    child: ListTile(
                      title: Text('User profile not found'),
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final String name = userData['name'] ?? 'User';
                final String email = currentUser?.email ?? 'No email';
                final String profileImageUrl = userData['imageUrl'] ?? '';

                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  shadowColor: Color.fromRGBO(196, 28, 13, 0.829),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: profileImageUrl.isNotEmpty
                              ? FileImage(File(profileImageUrl))
                              : const AssetImage('assets/Images/profile.jpg')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Poppins-Bold',
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              email,
                              style: const TextStyle(
                                  fontFamily: 'Poppins-Bold',
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            FutureBuilder<int>(
              future: getOrdersCount(currentUser?.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildProfileListTile(
                    title: 'Orders',
                    subtitle: 'Loading...',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShippingAddressesPage()),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return buildProfileListTile(
                    title: 'Shipping addresses',
                    subtitle: 'Error loading addresses',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShippingAddressesPage()),
                    ),
                  );
                }

                final addressCount = snapshot.data ?? 0;

                return buildProfileListTile(
                  title: 'Order History',
                  subtitle:
                      '$addressCount Order${addressCount != 1 ? 's' : ''}',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderListScreen()),
                  ),
                );
              },
            ),
            FutureBuilder<int>(
              future: getAddressCount(currentUser?.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildProfileListTile(
                    title: 'Shipping addresses',
                    subtitle: 'Loading...',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShippingAddressesPage()),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return buildProfileListTile(
                    title: 'Shipping addresses',
                    subtitle: 'Error loading addresses',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShippingAddressesPage()),
                    ),
                  );
                }

                final addressCount = snapshot.data ?? 0;

                return buildProfileListTile(
                  title: 'Shipping addresses',
                  subtitle:
                      '$addressCount address${addressCount != 1 ? 'es' : ''}',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShippingAddressesPage()),
                  ),
                );
              },
            ),
            StreamBuilder<WalletModel>(
              stream: walletRepo.getWallet(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildProfileListTile(
                    title: 'Wallet',
                    subtitle: 'Loading...',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalletScreen()),
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return buildProfileListTile(
                    title: 'Wallet',
                    subtitle: 'Error fetching wallet',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalletScreen()),
                    ),
                  );
                }

                final wallet = snapshot.data!;
                return buildProfileListTile(
                  title: 'Wallet',
                  subtitle: 'Balance: ${wallet.balance.toStringAsFixed(2)}',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WalletScreen()),
                  ),
                );
              },
            ),
            buildProfileListTile(
              title: 'Settings',
              subtitle: 'Edit Profile, password',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
