import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';

class RecommendationScreen extends StatelessWidget {


  final Map<String,dynamic> result;

  final String selectedCrop;

  final double temperature;

  final double humidity;

  final double rainfall;



  const RecommendationScreen({

    super.key,

    required this.result,

    required this.selectedCrop,

    required this.temperature,

    required this.humidity,

    required this.rainfall,

  });



  Widget buildCard({

    required IconData icon,

    required String title,

    required String value,

    required Color color,

  }){


    return Card(

      elevation:4,

      margin:
      const EdgeInsets.only(bottom:15),


      child:ListTile(


        leading:

        CircleAvatar(

          backgroundColor:
          color.withOpacity(0.15),


          child:

          Icon(

            icon,

            color:color,

          ),

        ),



        title:

        Text(

          title,

          style:

          const TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),



        subtitle:

        Text(

          value,

        ),



      ),


    );


  }





  @override
  Widget build(BuildContext context){

print(result);
    final cropResult = result;


final fertilizerResult =
result["fertilizer_recommendation"] ?? {};


final yieldResult =
result["yield_prediction"] ?? {};




    return Scaffold(


      appBar:

      AppBar(

        title:

        const Text(
          "AI Recommendation"
        ),

      ),



      body:

      SingleChildScrollView(


        padding:
        const EdgeInsets.all(20),



        child:

        Column(


          children:[



            const Icon(

              Icons.smart_toy,

              size:90,

              color:Colors.green,

            ),



            const SizedBox(height:15),



            const Text(

              "AI Analysis Completed 🌱",

              style:

              TextStyle(

                fontSize:24,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            const SizedBox(height:25),





            buildCard(

              icon:
              Icons.eco,

              title:
              "Selected Crop",

              value:
              selectedCrop,

              color:
              Colors.green,

            ),





            buildCard(

              icon:
              Icons.agriculture,

              title:
              "Recommended Crop",

              value:

              cropResult["recommended_crop"]
                  .toString(),

              color:
              Colors.green,

            ),





            buildCard(

              icon:
              Icons.grass,

              title:
              "Fertilizer",

              value:

fertilizerResult["recommended_fertilizer"] ??
"Not generated",

              color:
              Colors.orange,

            ),





            buildCard(

              icon:
              Icons.bar_chart,

              title:
              "Expected Yield",

              value:

yieldResult.isEmpty
?
"Not predicted"
:
"${yieldResult["predicted_yield_tons_per_hectare"]} Tons/Hectare",

              color:
              Colors.blue,

            ),





            buildCard(

              icon:
              Icons.cloud,

              title:
              "Weather Condition",

              value:

              "$temperature °C | $humidity % Humidity | $rainfall mm Rainfall",

              color:
              Colors.cyan,

            ),




            const SizedBox(height:20),



            SizedBox(

              width:
              double.infinity,


              child:

              ElevatedButton(

  onPressed: (){


    Navigator.pushAndRemoveUntil(

      context,


      MaterialPageRoute(

        builder:(_)=>
        const DashboardScreen(),

      ),


      (route)=>false,


    );


  },


  child:
  const Text(
    "Back to Dashboard"
  ),

),


            )



          ],


        ),


      ),


    );


  }


}