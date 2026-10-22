import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {

  static Future<Map<String, dynamic>> getWeather() async {

    // Bengaluru Coordinates
    const latitude = 12.9716;
    const longitude = 77.5946;

    final response = await http.get(

      Uri.parse(

        "https://api.open-meteo.com/v1/forecast"
        "?latitude=$latitude"
        "&longitude=$longitude"
        "&current=temperature_2m,relative_humidity_2m,weather_code"

      ),

    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    }

    throw Exception("Weather loading failed");

  }

}