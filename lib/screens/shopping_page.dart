import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/product_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/product_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/product_state.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/custom_search.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc()..add(FetchProductsEvent()),
      child: Scaffold(
        appBar: buildCustomAppBar(context: context, title: 'ShoppingPage'),
        body: Column(
          children: [
            customSearchField(context),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductErrorState) {
                  return Center(
                    child: Text(
                      'Error: ${state.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is ProductLoadedState) {
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return SizedBox(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                            elevation: 2,
                            shadowColor: Colors.red,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: product.imageUrls.isNotEmpty
                                      ? Image.memory(
                                          base64Decode(product.imageUrls.first),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                                Icons.image_not_supported);
                                          },
                                        )
                                      : const Icon(Icons.image_not_supported),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '⭐⭐⭐⭐⭐(5)',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        product.productName,
                                        style: styling(
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 20),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.brandName ?? 'Loading...',
                                        style: styling(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\₹${product.price.toStringAsFixed(2)}',
                                        style: styling(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
