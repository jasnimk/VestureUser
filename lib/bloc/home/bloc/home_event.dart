// // home/bloc/home_event.dart
// abstract class HomeEvent {}

// class LoadHomeData extends HomeEvent {}
// class RefreshHomeData extends HomeEvent {}
// class CopyCouponCode extends HomeEvent {
//   final String couponCode;
//   CopyCouponCode(this.couponCode);
// }

// home_event.dart
abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

class CopyCouponCode extends HomeEvent {
  final String couponCode;
  CopyCouponCode(this.couponCode);
}
