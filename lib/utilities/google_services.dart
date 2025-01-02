import 'dart:convert';
import 'dart:io';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:vesture_firebase_user/models/product_model.dart';

class GoogleVisionService {
  static const _scopes = [VisionApi.cloudVisionScope];

  Future<AutoRefreshingAuthClient> _getClient() async {
    // Replace with your Google Cloud credentials
    final credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "vesture-dc927",
      "private_key_id": "019b7912b0084f0877950fa14337201d70741e73",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDxt8ON23osqGop\nolLf6Q1kH1A08uiUe3+75SeAMczet1wlnpWh0wDHA7jooHAsSKUuR8kbyjp8nooc\n6ji9nhXM/Xk+ZDA2pustADgSRguG53+KQui2fFpo14KYVkcuE2mqeps+Q7b8qFmq\nFexArHHYUQshhhh6Oi0OH5FofnOyHbKS/uhbm4WELFW6kuyFvPqTcpY0oqz+sLgW\nqeuQNKClAwpWAz5uB0sYw1smgnTYyERwUakXVic4T0V/8xGZ6nD9fv/ZlFkD/Kf8\n2+AN4TPMPsfQj0SsMfoHtPBkf+2TrVBdSEwIYTghNp8xedRGwwlpa68l/WEvGk2m\nnDy995UxAgMBAAECggEAPp0kFmyaltPfgD5wqljT47Iq1DRyI/hjy7feBhqgX7bu\nsz4Ds8IVSvg/X18j/4yn4TeuNDkr8lkdHMVdglzfd9TXId7REG8nr2YFoFItrTnt\nc1LGtnK69rqQtUZwNNLJheQxr6zZy1QOufzo0I37BZZkxD/Yuly0jBqIT6Gl9aaz\n11cLiXINxmt77rL9LCqQq1fJt4hzvXdd+r1ivTfAV1Pp2FfgNqQLCl/F/T8G7Fap\n9m4Gm3fBsd1AHnmntxlkJR5i/3pNo7DP/O5bM83L/qpFMVMLF/Y0M/auJQY38hl1\n3cxIhglthtUjBCgozFR+5Jdb/EKFgBvjif7A9t3OUwKBgQD7p7aLypJdgIw1QT4r\nTIgVIqMuJ9iOwZAdRz54201IouyHSsB6mh/fyOnYLdQeLE3lhrNFKVKQPc2X/f7i\njXoF+9fmkFXSuRvJgNKZMjvHq/sNs74Ke/xmSPgti+qWIHHLPfM6psuIvkmmjNWh\n53ejjOl768YptH5cXQPzKQDQpwKBgQD15CELD6LBJgp6e1KhZyxkz/5i4V11Gz/Q\nG5L29CurO03MhAutlcG9ahdRVC8ncj0wIGF13Ax0Q2j4UIDjqVdrdW0pMnwGdlTI\npyyJ4I376zXVTqy2jsywIUjlFNI3+0pMcQoKrGc5Q3HD3g35Sc8hadbH43ZWFrVA\nY78DO8GOZwKBgQDV2u9BGnOJa+06cGgxiYb3VwkO9yOMJSegCeQn9k1V1cZlLnwl\ndAZ0ORun70IcJhBIZlDADF6yXyLw8BMDWbEBlsQhljSor0/SzFurfknY4+ij+0Qb\nSsPx9D6bDhTbYVTyn4GsLQQ3/2U9WN9PCBHedagQ/ArZdB4RxaXOpOChbwKBgCz0\nro3lJ+6EU/ocvfjAcj9kP7A4X+vfNYWI5Q+9iJZf21N++Nudu7Qzx1uZNp3Rpxo7\ncVYpCyXehTyRC1+UQGVnLLQRhNdxnwKofd4fbhYW5NrA7Zba+NVi4H7xlZWinezn\n5dwZtS2lBRG4cXmYYwRK43fcQHBw6maBVhTzQeoVAoGAFSQkFCepgmm/6eLmIy2G\nJBvClzadgXGrnFrztuPibpXJXCnMVLHfRRQseSL3gzSYKaUmAoNevOojr/HzHoEx\nCnwwiZzyJ8UDxTl413pMqGWeJdQufs1ArVWOthDGMOftvtsglRI0odwf5PAaPcmT\n1zL+n5o6XZihG3PDswlx9Fw=\n-----END PRIVATE KEY-----\n",
      "client_email": "jasni-345@vesture-dc927.iam.gserviceaccount.com",
      "client_id": "102875939926333556278",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/jasni-345%40vesture-dc927.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });

    return await clientViaServiceAccount(credentials, _scopes);
  }

  Future<List<String>> detectLabels(File imageFile) async {
    try {
      final client = await _getClient();
      final vision = VisionApi(client);

      final bytes = await imageFile.readAsBytes();
      print('Image bytes length: ${bytes.length}');

      final request = AnnotateImageRequest();
      request.image = Image()..content = base64Encode(bytes);
      request.features = [
        Feature()
          ..type = 'LABEL_DETECTION'
          ..maxResults = 10
      ];

      final batchRequest = BatchAnnotateImagesRequest()..requests = [request];
      final response = await vision.images.annotate(batchRequest);

      print('Vision API Response: ${response.toJson()}');

      final labels = response.responses?.first.labelAnnotations
              ?.map((annotation) {
                print(
                    'Label: ${annotation.description}, Score: ${annotation.score}');
                return annotation.description ?? '';
              })
              .where((label) => label.isNotEmpty)
              .toList() ??
          [];

      print('Final detected labels: $labels');
      client.close();
      return labels;
    } catch (e, stackTrace) {
      print('Error in detectLabels: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
