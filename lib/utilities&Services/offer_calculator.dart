class OfferCalculator {
  static double calculateFinalPrice(
      double originalPrice, double offerPercentage) {
    if (originalPrice <= 0 || offerPercentage <= 0) {
      return originalPrice;
    }

    double discountAmount = originalPrice * (offerPercentage / 100);
    double finalPrice = originalPrice - discountAmount;

    return finalPrice;
  }
}
