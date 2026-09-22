class CropModel {

  final String cropName;

  final String location;

  final String soilType;

  final String area;


  CropModel({

    required this.cropName,

    required this.location,

    required this.soilType,

    required this.area,

  });



  Map<String,dynamic> toJson(){

    return {

      "crop": cropName,

      "location": location,

      "soil": soilType,

      "area": area,

    };

  }

}