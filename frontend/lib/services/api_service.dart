import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {


  static const String baseUrl =
      "http://localhost:5000";



  // ===============================
  // CROP PREDICTION
  // ===============================


  static Future<Map<String,dynamic>> recommendCrop({

    required double n,
    required double p,
    required double k,

    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,

  }) async {


    final response = await http.post(


      Uri.parse(
        "$baseUrl/api/predict/crop",
      ),


      headers: {

        "Content-Type":
        "application/json"

      },


      body: jsonEncode({


        "N": n,

        "P": p,

        "K": k,


        "temperature":
        temperature,


        "humidity":
        humidity,


        "ph":
        ph,


        "rainfall":
        rainfall,


      }),

    );



    if(response.statusCode == 200){

      return jsonDecode(response.body);

    }


    throw Exception(
      "Crop prediction failed: ${response.body}"
    );


  }






  // ===============================
  // FERTILIZER RECOMMENDATION
  // ===============================


  static Future<Map<String,dynamic>> recommendFertilizer({


    required String soilType,

    required double soilPh,

    required double soilMoisture,


    required double organicCarbon,

    required double electricalConductivity,


    required double nitrogenLevel,

    required double phosphorusLevel,

    required double potassiumLevel,


    required double temperature,

    required double humidity,

    required double rainfall,


    required String cropType,


    required String cropGrowthStage,

    required String season,

    required String irrigationType,

    required String previousCrop,

    required String region,


    required double fertilizerUsedLastSeason,

    required double yieldLastSeason,


  }) async {



    final response = await http.post(


      Uri.parse(
        "$baseUrl/api/predict/fertilizer",
      ),


      headers: {

        "Content-Type":
        "application/json"

      },


      body: jsonEncode({


        "Soil_Type":
        soilType,


        "Soil_pH":
        soilPh,


        "Soil_Moisture":
        soilMoisture,


        "Organic_Carbon":
        organicCarbon,


        "Electrical_Conductivity":
        electricalConductivity,


        "Nitrogen_Level":
        nitrogenLevel,


        "Phosphorus_Level":
        phosphorusLevel,


        "Potassium_Level":
        potassiumLevel,


        "Temperature":
        temperature,


        "Humidity":
        humidity,


        "Rainfall":
        rainfall,


        "Crop_Type":
        cropType,


        "Crop_Growth_Stage":
        cropGrowthStage,


        "Season":
        season,


        "Irrigation_Type":
        irrigationType,


        "Previous_Crop":
        previousCrop,


        "Region":
        region,


        "Fertilizer_Used_Last_Season":
        fertilizerUsedLastSeason,


        "Yield_Last_Season":
        yieldLastSeason,


      }),

    );



    if(response.statusCode == 200){

      return jsonDecode(response.body);

    }


    throw Exception(
      "Fertilizer prediction failed: ${response.body}"
    );


  }



}