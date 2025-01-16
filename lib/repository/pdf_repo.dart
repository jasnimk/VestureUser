import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/widgets/custom_snackbar.dart';

/// A class to generate and manage invoice PDFs.
class InvoiceGenerator {
  /// Generates an invoice PDF for the given order.
  ///
  /// [order] The order model containing order details to be included in the invoice.
  /// Returns the generated [File] containing the invoice PDF.
  static Future<File> generateInvoice(OrderModel order) async {
    final pdf = pw.Document();

    // Adds content to the PDF document.
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header section with order information.
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('INVOICE',
                      style: pw.TextStyle(
                          fontSize: 40, fontWeight: pw.FontWeight.bold)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Order #${order.id.substring(0, 8)}'),
                      pw.Text(
                          'Date: ${order.createdAt.toString().split(' ')[0]}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              // Table displaying product details.
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Product',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Quantity',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Price',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Total',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...order.items
                      .map((item) => pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(item.productName),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(item.quantity.toString()),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    'Rs.${item.finalPrice.toStringAsFixed(2)}'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    'Rs.${item.totalAmount.toStringAsFixed(2)}'),
                              ),
                            ],
                          ))
                      .toList(),
                ],
              ),
              pw.SizedBox(height: 20),
              // Footer with totals and charges.
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                        'Subtotal: Rs.${order.subTotal.toStringAsFixed(2)}'),
                    pw.Text(
                        'Discount: Rs.${order.totalDiscount.toStringAsFixed(2)}'),
                    pw.Text(
                        'Shipping: Rs.${order.shippingCharge.toStringAsFixed(2)}'),
                    pw.Text('Total: Rs.${order.totalAmount.toStringAsFixed(2)}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the generated PDF to a temporary file.
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/Invoice_${order.id.substring(0, 8)}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Downloads and shares the generated invoice for the given order.
  ///
  /// [order] The order model containing order details for the invoice.
  /// [share] A boolean to specify whether the invoice should be shared or saved locally.
  /// [context] The BuildContext for showing snackbars and opening the file.
  static Future<void> downloadAndShare(
      OrderModel order, bool share, BuildContext context) async {
    try {
      CustomSnackBar.show(
        context,
        message: 'Please wait invoice is generating...!',
        textColor: Colors.white,
      );
      final file = await generateInvoice(order);

      // Share the invoice if requested.
      if (share) {
        await Share.shareXFiles(
          [XFile(file.path)],
          subject: 'Invoice for Order #${order.id.substring(0, 8)}',
        );
      } else {
        // Save the invoice locally and provide option to open it.
        final output = await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
        final savedFile = await file
            .copy('${output.path}/Invoice_${order.id.substring(0, 8)}.pdf');

        if (context.mounted) {
          CustomSnackBar.show(
            context,
            message: 'Please wait while products are loading...!',
            textColor: Colors.white,
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                final result = await OpenFile.open(savedFile.path);
                if (result.type != ResultType.done && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error opening file: ${result.message}'),
                    ),
                  );
                }
              },
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
