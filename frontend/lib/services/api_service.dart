import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000";

  static Future<Map<String, dynamic>> analyzeCrop({
    required String crop,
    required int n,
    required int p,
    required int k,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/analyze"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        // Crop model inputs - ACTUAL USER VALUES
        "N": n,
        "P": p,
        "K": k,
        "temperature": temperature,
        "humidity": humidity,
        "ph": ph,
        "rainfall": rainfall,

        // Yield model inputs
        // Some fields are not collected by the current UI,
        // so temporary defaults are used for those fields.
        "State": "Karnataka",
        "Crop": crop,
        "Season": "Kharif",
        "Area": 5.2,
        "Rainfall": rainfall,
        "Fertilizer": 120,
        "Pesticide": 4.5,
        "Temperature": temperature,

        // Fertilizer model inputs
        "Humidity": humidity,
        "Moisture": 38,
        "Soil_Type": "Loamy",
        "Crop_Type": crop,
        "Nitrogen": n,
        "Phosphorous": p,
        "Potassium": k,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "Status Code: ${response.statusCode}\n"
      "Response: ${response.body}",
    );
  }
}