import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../recommendation/recommendation_screen.dart';


class AnalysisLoadingScreen extends StatefulWidget {


  final String crop;

  final int n;
  final int p;
  final int k;


  final double temperature;
  final double humidity;
  final double ph;
  final double rainfall;


  final String soilType;
  final double soilMoisture;



  const AnalysisLoadingScreen({

    super.key,

    required this.crop,

    required this.n,
    required this.p,
    required this.k,

    required this.temperature,
    required this.humidity,
    required this.ph,
    required this.rainfall,

    required this.soilType,
    required this.soilMoisture,

  });



  @override
  State<AnalysisLoadingScreen> createState() =>
      _AnalysisLoadingScreenState();

}




class _AnalysisLoadingScreenState
extends State<AnalysisLoadingScreen>{



@override
void initState(){

super.initState();

startAnalysis();

}




Future<void> startAnalysis() async {


try{


// Show AI loading animation

await Future.delayed(
const Duration(seconds:3),
);



// ===============================
// CROP PREDICTION
// ===============================


final cropResult =
await ApiService.recommendCrop(

n: widget.n.toDouble(),

p: widget.p.toDouble(),

k: widget.k.toDouble(),

temperature:
widget.temperature,

humidity:
widget.humidity,

ph:
widget.ph,

rainfall:
widget.rainfall,

);





// ===============================
// FERTILIZER PREDICTION
// ===============================



final fertilizerResult =
await ApiService.recommendFertilizer(


soilType:
widget.soilType,


soilPh:
widget.ph,


soilMoisture:
widget.soilMoisture,



// Default values for hidden fields

organicCarbon:
1.2,


electricalConductivity:
0.8,



nitrogenLevel:
widget.n.toDouble(),


phosphorusLevel:
widget.p.toDouble(),


potassiumLevel:
widget.k.toDouble(),



temperature:
widget.temperature,


humidity:
widget.humidity,


rainfall:
widget.rainfall,



cropType:
widget.crop,



cropGrowthStage:
"Vegetative",


season:
"Kharif",


irrigationType:
"Drip",


previousCrop:
"Rice",


region:
"South",



fertilizerUsedLastSeason:
1,


yieldLastSeason:
3.5,

);





if(!mounted) return;




final result = {


"crop_prediction":
cropResult,


"fertilizer_recommendation":
fertilizerResult,

};





Navigator.pushReplacement(

context,


MaterialPageRoute(

builder: (_) => RecommendationScreen(

result: result,

),

),

);



}

catch(e){


if(!mounted) return;



ScaffoldMessenger.of(context)
.showSnackBar(


SnackBar(

content: Text(
"Prediction failed: $e",
),

),


);



Navigator.pop(context);



}



}







@override
Widget build(BuildContext context){


return Scaffold(


body:Center(


child:Column(


mainAxisAlignment:
MainAxisAlignment.center,



children:[



const Icon(

Icons.smart_toy,

size:90,

color:Colors.green,

),



const SizedBox(height:30),




const Text(

"AI is analyzing your crop 🌱",

style:TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

),

),




const SizedBox(height:20),




const Text(

"Checking soil conditions\nGenerating recommendations",

textAlign:TextAlign.center,

style:TextStyle(

color:Colors.grey,

),

),




const SizedBox(height:30),




const CircularProgressIndicator(),



],


),


),


);



}



}