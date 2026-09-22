import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {

  static const String baseUrl =
      "http://127.0.0.1:5000";


  static Future<Map<String,dynamic>> analyzeCrop() async {


    final response = await http.post(

      Uri.parse(
        "$baseUrl/api/analyze",
      ),

      headers: {
        "Content-Type": "application/json"
      },


      body: jsonEncode({

        "N": 90,
        "P": 42,
        "K": 43,

        "temperature": 20.8,
        "humidity": 82.0,
"Humidity": 82.0,
        "ph": 6.5,
        "rainfall": 202.9,


        "State": "Karnataka",
        "Crop": "Rice",
        "Season": "Kharif",

        "Area": 5.2,
        "Rainfall": 1200,
        "Fertilizer": 120,
        "Pesticide": 4.5,
        "Temperature": 27,


        "Moisture": 38,
        "Soil_Type": "Loamy",
        "Crop_Type": "Rice",

        "Nitrogen": 37,
        "Phosphorous": 0,
        "Potassium": 0,

      }),

    );

    print("Status: ${response.statusCode}");
print("Body: ${response.body}");

    if(response.statusCode == 200){

      return jsonDecode(response.body);

    }
    else{

      throw Exception(
  "Status Code: ${response.statusCode}\nResponse: ${response.body}"
);

    }

  }

}