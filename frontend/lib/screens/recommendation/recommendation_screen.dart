import 'package:flutter/material.dart';


class RecommendationScreen extends StatelessWidget {


  final Map<String,dynamic> result;


  const RecommendationScreen({

    super.key,

    required this.result,

  });





  Widget buildResultCard(

      String title,

      String value,

      IconData icon,

      Color color) {


    return Card(

      elevation: 3,


      child: ListTile(


        leading: CircleAvatar(

          backgroundColor:
          color.withOpacity(0.2),


          child: Icon(

            icon,

            color: color,

          ),

        ),



        title: Text(title),



        subtitle: Text(

          value,

          style: const TextStyle(

            fontWeight:
            FontWeight.bold,

            fontSize:16,

          ),

        ),



      ),

    );


  }






  @override

  Widget build(BuildContext context) {



    print(result);



    // Extract AI responses

    final cropResult =
    result["crop_prediction"]
    ?? {};


    final fertilizerResult =
    result["fertilizer_recommendation"]
    ?? {};





    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "AI Recommendation",
        ),

      ),





      body: Padding(


        padding:
        const EdgeInsets.all(16),



        child: Column(



          children: [



            const Text(

              "🌱 AI Analysis Completed",

              style: TextStyle(

                fontSize:24,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            const SizedBox(height:20),





            buildResultCard(

              "Recommended Crop",

              cropResult["recommended_crop"]
              ?.toString()
              ??
              "Not Available",

              Icons.grass,

              Colors.green,

            ),





            buildResultCard(

              "Recommended Fertilizer",

              fertilizerResult["recommended_fertilizer"]
              ?.toString()
              ??
              "Not Available",

              Icons.eco,

              Colors.orange,

            ),





            buildResultCard(

              "Soil Condition",

              "Analyzed using AI soil parameters",

              Icons.landscape,

              Colors.brown,

            ),





            buildResultCard(

              "Climate Analysis",

              "Temperature, humidity and rainfall considered",

              Icons.cloud,

              Colors.blue,

            ),




          ],


        ),


      ),


    );


  }

}