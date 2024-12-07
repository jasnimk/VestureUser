import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProductBloc() : super(ProductInitialState()) {
    on<FetchProductsEvent>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();

      List<Product> products = [];
      for (var doc in querySnapshot.docs) {
        Product product = Product.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );

     
        await product.fetchBrandName();
        products.add(product);
      }

      emit(ProductLoadedState(products: products));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }
}
