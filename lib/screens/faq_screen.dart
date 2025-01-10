import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/utilities&Services/faq.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'FAQs'),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    shape: BeveledRectangleBorder(),
                    child: ExpansionTile(
                      title: Text(
                        faqs[index]['question']!,
                        style: headerStyling(fontSize: 15),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            faqs[index]['answer']!,
                            style: styling(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
