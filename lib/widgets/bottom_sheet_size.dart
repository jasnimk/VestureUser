import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

Future<void> showCustomBottomSheet({
  required BuildContext context,
  required List<SizeStockModel> availableSizes,
  SizeStockModel? initialSelectedSize,
  required Function(SizeStockModel) onSizeSelected,
  Color? backgroundColor,
  double? height,
  bool isDismissible = true,
  String? actionButtonLabel,
  Function(SizeStockModel)? actionCallback,
  bool isCartAction = true,
}) {
  debugPrint(
      'Opening bottom sheet with isCartAction: $isCartAction'); // Debug print
  final ValueNotifier<SizeStockModel?> selectedSizeNotifier =
      ValueNotifier<SizeStockModel?>(initialSelectedSize);

  return showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    backgroundColor: backgroundColor ?? Colors.white,
    isScrollControlled: true,
    builder: (BuildContext bottomSheetContext) {
      return Container(
        height: height ?? MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Size',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(bottomSheetContext),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableSizes.map((sizeStock) {
                return ValueListenableBuilder<SizeStockModel?>(
                  valueListenable: selectedSizeNotifier,
                  builder: (context, selectedSize, _) {
                    return ChoiceChip(
                      label: Text('${sizeStock.size} (${sizeStock.stock})'),
                      selected: selectedSize?.id == sizeStock.id,
                      onSelected: sizeStock.stock > 0
                          ? (bool selected) {
                              selectedSizeNotifier.value = sizeStock;
                              onSizeSelected(sizeStock);
                            }
                          : null,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      disabledColor: Colors.grey[300],
                      labelStyle: TextStyle(
                        color: sizeStock.stock > 0
                            ? (selectedSize?.id == sizeStock.id
                                ? Colors.white
                                : Colors.black)
                            : Colors.grey,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            if (actionButtonLabel != null)
              customButton(
                height: 50,
                context: context,
                text: actionButtonLabel,
                onPressed: () {
                  if (selectedSizeNotifier.value != null &&
                      actionCallback != null) {
                    debugPrint(
                        'Action button pressed with isCartAction: $isCartAction');

                    actionCallback(selectedSizeNotifier.value!);

                    Navigator.pop(bottomSheetContext);

                    _showSuccessDialog(
                      context: context,
                      isCartAction: isCartAction,
                    );
                  }
                },
                icon:
                    isCartAction ? Icons.shopping_cart : Icons.favorite_border,
              ),
          ],
        ),
      );
    },
  );
}

void _showSuccessDialog({
  required BuildContext context,
  required bool isCartAction,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        title: Column(
          children: [
            const Icon(
              FontAwesomeIcons.check,
              color: Color.fromARGB(255, 177, 35, 25),
              size: 70,
            ),
          ],
        ),
        content: Text(
          isCartAction
              ? 'Product added to cart successfully!'
              : 'Product added to favorites successfully!',
          textAlign: TextAlign.center,
          style: styling(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text(
              'OK',
              style: styling(fontSize: 20),
            ),
          ),
        ],
      );
    },
  );
}
