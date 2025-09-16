import 'package:http/http.dart' as http;
import 'package:prasta/api/endpoint/endpoint.dart';
import 'package:prasta/models/list_batch_model.dart';
import 'package:prasta/shared_preferenced/preferenced.dart';

class BatchService {
  /// Fetch semua cinema
  static Future<List<Datum>> fetchbatch() async {
    final url = Uri.parse(Endpoint.batch);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = listBatchModelFromJson(
        response.body,
      ); // decode JSON ke model
      return data.data ?? [];
    } else {
      throw Exception("Gagal load batch (${response.statusCode})");
    }
  }
}
