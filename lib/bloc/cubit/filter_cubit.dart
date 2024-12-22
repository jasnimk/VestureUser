// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/cubit/filter_cubit.dart';
// import 'package:vesture_firebase_user/bloc/cubit/filter_state.dart';
// import 'package:vesture_firebase_user/models/product_filter.dart';
// import 'package:vesture_firebase_user/repository/filter_repo.dart';

// class FilterCubit extends Cubit<FilterState> {
//   final FilterRepository repository;

//   FilterCubit(this.repository) : super(FilterLoading());

//   void loadFilters() async {
//     try {
//       final filterData = await repository.fetchFilterData();
//       emit(FilterLoaded(
//         priceRange: filterData['priceRange'],
//         colors: filterData['colors'],
//         sizes: filterData['sizes'],
//         categories: filterData['categories'],
//         brands: filterData['brands'],
//       ));
//     } catch (e) {
//       emit(FilterError(message: e.toString()));
//     }
//   }

//   void updateFilter(ProductFilter newFilter) {
//     emit(FilterUpdated(newFilter: newFilter));
//   }
// }
