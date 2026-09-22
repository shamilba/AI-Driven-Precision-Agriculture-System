class PredictionModel {

  final String health;
  final String disease;
  final String yieldPrediction;
  final String fertilizer;
  final String irrigation;


  PredictionModel({

    required this.health,

    required this.disease,

    required this.yieldPrediction,

    required this.fertilizer,

    required this.irrigation,

  });



  factory PredictionModel.fromJson(
      Map<String, dynamic> json
      ){

    return PredictionModel(

      health: json["health"] ?? "",

      disease: json["disease"] ?? "",

      yieldPrediction: json["yield"] ?? "",

      fertilizer: json["fertilizer"] ?? "",

      irrigation: json["irrigation"] ?? "",

    );

  }

}