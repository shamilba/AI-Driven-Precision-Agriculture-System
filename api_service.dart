// lib/services/api_service.dart
//
// Example service showing how your existing Flutter app (see main.dart /
// SplashScreen) can call this Python backend. Drop this into lib/services/
// and set `baseUrl` to wherever you deploy app.py.
//
// Add to pubspec.yaml:  http: ^1.2.2

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android emulator -> host machine: 10.0.2.2
  // iOS simulator / desktop -> localhost
  // Physical device -> your machine's LAN IP, e.g. http://192.168.1.20:5000
  static const String baseUrl = "http://10.0.2.2:5000";

  static Future<Map<String, dynamic>> recommendCrop({
    required double n,
    required double p,
    required double k,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/predict/crop"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "N": n,
        "P": p,
        "K": k,
        "temperature": temperature,
        "humidity": humidity,
        "ph": ph,
        "rainfall": rainfall,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception("Crop prediction failed: ${response.body}");
  }

  static Future<Map<String, dynamic>> predictYield({
    required String state,
    required String crop,
    required String season,
    required double area,
    required double rainfall,
    required double fertilizer,
    required double pesticide,
    required double temperature,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/predict/yield"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "State": state,
        "Crop": crop,
        "Season": season,
        "Area": area,
        "Rainfall": rainfall,
        "Fertilizer": fertilizer,
        "Pesticide": pesticide,
        "Temperature": temperature,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception("Yield prediction failed: ${response.body}");
  }

  static Future<Map<String, dynamic>> recommendFertilizer({
    required double temperature,
    required double humidity,
    required double moisture,
    required String soilType,
    required String cropType,
    required double nitrogen,
    required double phosphorous,
    required double potassium,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/predict/fertilizer"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "Temperature": temperature,
        "Humidity": humidity,
        "Moisture": moisture,
        "Soil_Type": soilType,
        "Crop_Type": cropType,
        "Nitrogen": nitrogen,
        "Phosphorous": phosphorous,
        "Potassium": potassium,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception("Fertilizer prediction failed: ${response.body}");
  }
}
