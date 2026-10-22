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

        "temperature": temperature,
        "humidity": humidity,
        "ph": ph,
        "rainfall": rainfall,

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
  // FERTILIZER PREDICTION
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
        "$baseUrl/api/predict/fertilizer"
      ),



      headers:{

        "Content-Type":
        "application/json"

      },



      body:jsonEncode({


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







  // ===============================
  // YIELD PREDICTION
  // ===============================


  static Future<Map<String,dynamic>> recommendYield({


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


      Uri.parse(
        "$baseUrl/api/predict/yield"
      ),



      headers:{

        "Content-Type":
        "application/json"

      },



      body:jsonEncode({


        "State":
        state,


        "Crop":
        crop,


        "Season":
        season,


        "Area":
        area,


        "Rainfall":
        rainfall,


        "Fertilizer":
        fertilizer,


        "Pesticide":
        pesticide,


        "Temperature":
        temperature,


      }),


    );




    if(response.statusCode == 200){

      return jsonDecode(response.body);

    }



    throw Exception(

      "Yield prediction failed: ${response.body}"

    );


  }







  // ===============================
  // SAVE HISTORY
  // ===============================


  static Future<void> saveHistory({


    required int userId,


    required String selectedCrop,


    required String recommendedCrop,


    required String fertilizer,


    required double yieldPrediction,


    required double temperature,


    required double humidity,


    required double rainfall,


  }) async {



    final response = await http.post(


      Uri.parse(

        "$baseUrl/api/history/save"

      ),



      headers:{


        "Content-Type":

        "application/json"


      },



      body:jsonEncode({


        "user_id":
        userId,


        "selected_crop":
        selectedCrop,


        "recommended_crop":
        recommendedCrop,


        "fertilizer":
        fertilizer,


        "yield_prediction":
        yieldPrediction,


        "temperature":
        temperature,


        "humidity":
        humidity,


        "rainfall":
        rainfall,


      }),


    );





    if(response.statusCode != 201){


      throw Exception(

        "Failed to save history"

      );


    }



  }







  // ===============================
  // GET HISTORY
  // ===============================


  static Future<List<dynamic>> getHistory(

      int userId

      ) async {



    final response = await http.get(


      Uri.parse(

        "$baseUrl/api/history/$userId"

      ),


    );




    if(response.statusCode == 200){


      return jsonDecode(response.body);


    }



    throw Exception(

      "Failed to load history"

    );


  }







  // ===============================
  // LOGIN
  // ===============================


  static Future<Map<String,dynamic>> login({


    required String email,


    required String password,


  }) async {



    final response = await http.post(



      Uri.parse(

        "$baseUrl/api/login"

      ),



      headers:{


        "Content-Type":

        "application/json"


      },



      body:jsonEncode({


        "email":

        email,


        "password":

        password,


      }),



    );





    if(response.statusCode == 200){


      return jsonDecode(response.body);


    }




    final error =
    jsonDecode(response.body);



    throw Exception(

      error["error"]

      ??


      "Login failed"

    );


  }

// ===============================
// GET LATEST ANALYSIS
// ===============================

static Future<Map<String,dynamic>> getLatestAnalysis(

int userId

) async {


final response = await http.get(

Uri.parse(
"$baseUrl/api/history/latest/$userId"
),

);



if(response.statusCode == 200){

return jsonDecode(response.body);

}



throw Exception(
"Failed to load latest analysis"
);


}
// ===============================
// REGISTER USER
// ===============================

static Future<Map<String,dynamic>> register({

required String name,

required String email,

required String password,

required String location,


}) async {


final response = await http.post(


Uri.parse(
"$baseUrl/api/register"
),



headers:{


"Content-Type":
"application/json"


},



body:jsonEncode({


"name":name,

"email":email,

"password":password,

"location":location,


}),



);



if(response.statusCode == 201){


return jsonDecode(response.body);


}



throw Exception(

jsonDecode(response.body)["error"]

??

"Registration failed"

);



}

}