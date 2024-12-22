import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //backgroundColor: Theme.of(context).colorScheme.tertiary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      title: Text(
        title,
        style: styling(
            fontFamily: 'Poppins-Bold',
            fontSize: 20,
            color: Color.fromRGBO(196, 28, 13, 0.829)),
      ),
      content: Text(
        content,
        style: styling(fontSize: 14),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onCancel();
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: styling(),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(196, 28, 13, 0.829),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: Text(
            'Confirm',
            style: styling(
                fontFamily: 'Poppins-Regular',
                fontSize: 14,
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}
