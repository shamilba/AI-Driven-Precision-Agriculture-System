import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/api_service.dart';

import '../recommendation/recommendation_screen.dart';



class AnalysisLoadingScreen extends StatefulWidget {


  const AnalysisLoadingScreen({
    super.key
  });



  @override
  State<AnalysisLoadingScreen> createState()
      => _AnalysisLoadingScreenState();


}





class _AnalysisLoadingScreenState
extends State<AnalysisLoadingScreen>{



@override
void initState(){


  super.initState();



  startAnalysis();


}





void startAnalysis(){


  Timer(

    const Duration(seconds:3),


    () async {


      try{


        final result =
        await ApiService.analyzeCrop();



        if(mounted){


          Navigator.pushReplacement(

            context,


            MaterialPageRoute(

              builder:(_)=>

              RecommendationScreen(

                result: result,

              ),


            ),


          );


        }


      }


      catch(e){


        if(mounted){


          ScaffoldMessenger.of(context)
          .showSnackBar(

            SnackBar(

              content: Text(
                e.toString()
              ),

            ),

          );


        }


      }


    },

  );


}





@override
Widget build(BuildContext context){


return Scaffold(


body: Center(


child: Column(


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




const CircularProgressIndicator(),



],


),


),


);



}


}