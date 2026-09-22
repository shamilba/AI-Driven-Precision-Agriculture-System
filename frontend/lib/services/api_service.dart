import '../model/prediction_model.dart';


class ApiService {


  Future<PredictionModel> analyzeCrop() async {


    await Future.delayed(

      const Duration(seconds:2),

    );


    return PredictionModel(

      health: "Healthy",

      disease: "No Disease Found",

      yieldPrediction: "4.8 Tons/Hectare",

      fertilizer: "NPK 20-20-20",

      irrigation: "Water after 2 Days",

    );


  }


}