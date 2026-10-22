import 'dart:async';
import 'package:flutter/material.dart';

import '../recommendation/recommendation_screen.dart';
import '../../services/api_service.dart';



class AnalysisLoadingScreen extends StatefulWidget {


  final String crop;

  final double n;
  final double p;
  final double k;

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



Timer? timer;


String message =
"Analyzing soil data...";







@override
void initState(){

super.initState();

startAnalysis();

}







void startAnalysis(){


timer = Timer.periodic(

const Duration(seconds:2),

(t){


if(!mounted){

t.cancel();

return;

}



setState((){


if(message=="Analyzing soil data..."){

message="Checking crop health...";

}

else if(message=="Checking crop health..."){

message="Generating AI recommendation...";

}

else if(message=="Generating AI recommendation..."){

message="Calculating final results...";

}

else{

message="Preparing report...";

}



});


}

);



runAIAnalysis();


}









Future<void> runAIAnalysis() async {


try{


final result = await ApiService.recommendCrop(


n: widget.n,

p: widget.p,

k: widget.k,


temperature: widget.temperature,

humidity: widget.humidity,

ph: widget.ph,

rainfall: widget.rainfall,


);





if(!mounted)return;


timer?.cancel();





Navigator.pushReplacement(

context,


MaterialPageRoute(

builder:(_)=>


RecommendationScreen(


selectedCrop: widget.crop,


result: result,


temperature: widget.temperature,


humidity: widget.humidity,


rainfall: widget.rainfall,


),


),


);



}



catch(e){


timer?.cancel();


print(

"Analysis error: $e"

);



if(!mounted)return;



ScaffoldMessenger.of(context)
.showSnackBar(


SnackBar(

content:

Text(

"Analysis failed: $e"

),

),


);



}



}









@override
void dispose(){


timer?.cancel();


super.dispose();


}









@override
Widget build(BuildContext context){


return Scaffold(



body:

Center(


child:

Column(


mainAxisAlignment:

MainAxisAlignment.center,


children:[



const Icon(

Icons.smart_toy,

size:90,

color:Colors.green,

),




const SizedBox(height:25),





const Text(

"AI Crop Analysis",

style:

TextStyle(

fontSize:26,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(height:25),




const CircularProgressIndicator(),





const SizedBox(height:25),





AnimatedSwitcher(

duration:

const Duration(milliseconds:500),



child:

Text(

message,

key:

ValueKey(message),

style:

const TextStyle(

fontSize:17,

),

),


),



],


),


),


);



}



}