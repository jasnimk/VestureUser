import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/repository/cart_repo.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CartRepository cartRepository;

  ProductDetailsBloc({required this.cartRepository})
      : super(ProductDetailsInitialState()) {
    on<FetchProductDetailsEvent>(_onFetchProductDetails);
    on<SelectColorVariantEvent>(_onSelectColorVariant);
    on<SelectSizeEvent>(_onSelectSize);
    on<AddToCartEvent>(_onAddToCart);
  }

  Future<void> _onFetchProductDetails(
      FetchProductDetailsEvent event, Emitter<ProductDetailsState> emit) async {
    try {
      emit(ProductDetailsLoadingState());

      final productDoc =
          await _firestore.collection('products').doc(event.productId).get();

      // Fetch brand name
      String? brandName;
      final brandDoc = await _firestore
          .collection('brands')
          .doc(productDoc.data()!['brandId'])
          .get();

      brandName = brandDoc.data()?['name'] ??
          brandDoc.data()?['brandName'] ??
          brandDoc.data()?['title'] ??
          'Unknown Brand';

      final variantsSnapshot = await _firestore
          .collection('variants')
          .where('productId', isEqualTo: event.productId)
          .get();

      List<Variant> variants = [];
      for (var variantDoc in variantsSnapshot.docs) {
        final sizeStocksSnapshot = await _firestore
            .collection('sizes_and_stocks')
            .where('variantId', isEqualTo: variantDoc.id)
            .get();

        List<SizeStockModel> sizeStocks = sizeStocksSnapshot.docs
            .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
            .toList();

        variants
            .add(Variant.fromMap(variantDoc.data(), variantDoc.id, sizeStocks));
      }

      if (variants.isEmpty) {
        emit(ProductDetailsErrorState(
            errorMessage: 'No variants available for this product.'));
        return;
      }

      final product =
          ProductModel.fromFirestore(productDoc, variants, brandName);

      Variant? selectedVariant;
      SizeStockModel? selectedSize;

      for (var variant in variants) {
        selectedSize = variant.sizeStocks.firstWhere(
          (size) => size.stock > 0,
          orElse: () => SizeStockModel(
              stock: 0,
              id: '',
              size: '',
              baseprice: 0,
              percentDiscount: 0,
              variantId: ''),
        );

        if (selectedSize.stock > 0) {
          selectedVariant = variant;
          break;
        }
      }

      if (selectedVariant == null ||
          selectedSize == null ||
          selectedSize.stock == 0) {
        emit(ProductDetailsErrorState(
            errorMessage: 'No available stock for this product.'));
        return;
      }

      emit(ProductDetailsLoadedState(
        product: product,
        selectedVariant: selectedVariant,
        selectedSize: selectedSize,
        availableVariants: variants,
      ));
    } catch (e) {
      emit(ProductDetailsErrorState(errorMessage: e.toString()));
    }
  }

  void _onSelectColorVariant(
      SelectColorVariantEvent event, Emitter<ProductDetailsState> emit) {
    if (state is ProductDetailsLoadedState) {
      final currentState = state as ProductDetailsLoadedState;

      final firstAvailableSize = event.selectedVariant.sizeStocks.firstWhere(
        (size) => size.stock > 0,
        orElse: () => event.selectedVariant.sizeStocks.first,
      );

      emit(ProductDetailsLoadedState(
        product: currentState.product,
        selectedVariant: event.selectedVariant,
        availableVariants: currentState.availableVariants,
        selectedSize: firstAvailableSize,
      ));
    }
  }

  void _onSelectSize(SelectSizeEvent event, Emitter<ProductDetailsState> emit) {
    if (state is ProductDetailsLoadedState) {
      final currentState = state as ProductDetailsLoadedState;
      emit(ProductDetailsLoadedState(
        product: currentState.product,
        selectedVariant: currentState.selectedVariant,
        selectedSize: event.selectedSize,
        availableVariants: currentState.availableVariants,
      ));
    }
  }

  Future<void> _onAddToCart(
      AddToCartEvent event, Emitter<ProductDetailsState> emit) async {
    try {
      emit(ProductDetailsLoadingState());

      await cartRepository.addToCart(
        event.product,
        event.selectedVariant,
        event.selectedSize,
        event.quantity,
      );

      emit(AddToCartSuccessState(message: 'Item added to cart successfully'));

      add(FetchProductDetailsEvent(productId: event.product.id!));
    } catch (e) {
      emit(AddToCartErrorState(errorMessage: e.toString()));
    }
  }
}
