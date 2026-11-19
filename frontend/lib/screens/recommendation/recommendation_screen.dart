import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dashboard/dashboard_screen.dart';
import '../../services/crop_translation_service.dart';
import '../../localization/app_localizations.dart';
import '../../services/language_service.dart';



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





  String t(BuildContext context,String key){


    final language =

    Provider.of<LanguageService>(context)
        .language;



    return AppLocalizations.translate(

      key,

      language,

    );


  }
    Widget buildSmallCard({

    required IconData icon,

    required String title,

    required String value,

    required Color color,

  }){


    return Container(

      padding:

      const EdgeInsets.all(8),


      decoration:

      BoxDecoration(

        color:Colors.white,

        borderRadius:

        BorderRadius.circular(12),


        boxShadow:[


          const BoxShadow(

            color:Colors.black12,

            blurRadius:3,

            offset:Offset(0,2),

          )


        ],

      ),



      child:

      Column(

        mainAxisAlignment:

        MainAxisAlignment.center,


        children:[



          CircleAvatar(

            radius:14,


            backgroundColor:

            color.withValues(alpha:0.15),


            child:

            Icon(

              icon,

              size:16,

              color:color,

            ),

          ),




          const SizedBox(height:5),




          Text(

            title,

            textAlign:

            TextAlign.center,


            style:

            const TextStyle(

              fontSize:11,

              fontWeight:

              FontWeight.bold,

            ),

          ),




          const SizedBox(height:3),




          Text(

            value,

            textAlign:

            TextAlign.center,


            maxLines:2,

            overflow:

            TextOverflow.ellipsis,


            style:

            const TextStyle(

              fontSize:10,

            ),

          ),


        ],

      ),

    );

  }






  Widget buildFertilizerCard(

      dynamic fertilizer,

      BuildContext context,

      ){



    String fertilizerName =

    fertilizer["recommended_fertilizer"]

        ??

    "Not Generated";




    String nitrogen="N/A";

    String phosphorus="N/A";

    String potassium="N/A";




    List<String> npk =

    fertilizerName.split("-");




    if(npk.length==3){


      nitrogen=npk[0];

      phosphorus=npk[1];

      potassium=npk[2];


    }


    else if(fertilizerName.toLowerCase()=="dap"){


      nitrogen="18";

      phosphorus="46";

      potassium="0";


    }


    else if(fertilizerName.toLowerCase()=="urea"){


      nitrogen="46";

      phosphorus="0";

      potassium="0";


    }


    else if(fertilizerName.toLowerCase()=="mop"){


      nitrogen="0";

      phosphorus="0";

      potassium="60";


    }




    return Container(


      width:

      double.infinity,



      padding:

      const EdgeInsets.all(12),




      decoration:

      BoxDecoration(


        color:

        Colors.orange.shade50,


        borderRadius:

        BorderRadius.circular(15),



        border:

        Border.all(

          color:

          Colors.orange,

        ),


      ),




      child:

      Column(


        crossAxisAlignment:

        CrossAxisAlignment.start,



        children:[




          Row(

            children:[



              const Icon(

                Icons.science,

                color:Colors.orange,

                size:20,

              ),




              const SizedBox(width:8),




              Text(

                t(context,"fertilizer_recommendation"),

                style:

                const TextStyle(

                  fontSize:14,

                  fontWeight:

                  FontWeight.bold,

                ),

              ),



            ],

          ),




          const SizedBox(height:10),





          Text(

            "$fertilizerName NPK",


            style:

            const TextStyle(

              fontSize:18,

              fontWeight:

              FontWeight.bold,

            ),

          ),




          const SizedBox(height:10),




          Row(

            mainAxisAlignment:

            MainAxisAlignment.spaceAround,


            children:[



              Text(

                "N\n$nitrogen%",

                textAlign:

                TextAlign.center,

              ),



              Text(

                "P\n$phosphorus%",

                textAlign:

                TextAlign.center,

              ),



              Text(

                "K\n$potassium%",

                textAlign:

                TextAlign.center,

              ),



            ],

          ),





          const SizedBox(height:10),





          Text(

            t(context,"fertilizer_description"),

            style:

            const TextStyle(

              fontSize:11,

            ),

          ),



        ],

      ),


    );

  }
    String getCropEmoji(String crop){


    crop=crop.toLowerCase();



    if(crop.contains("rice")){

      return "🌾";

    }

    else if(crop.contains("wheat")){

      return "🌾";

    }

    else if(crop.contains("maize") ||
            crop.contains("corn")){

      return "🌽";

    }

    else if(crop.contains("tomato")){

      return "🍅";

    }

    else if(crop.contains("potato")){

      return "🥔";

    }

    else if(crop.contains("mango")){

      return "🥭";

    }

    else if(crop.contains("banana")){

      return "🍌";

    }


    return "🌱";


  }






  Widget buildInsightsCard(BuildContext context){


    return Container(


      width:

      double.infinity,



      padding:

      const EdgeInsets.all(12),




      decoration:

      BoxDecoration(


        color:

        Colors.green.shade50,



        borderRadius:

        BorderRadius.circular(15),




        border:

        Border.all(

          color:

          Colors.green,

        ),


      ),




      child:

      Column(


        crossAxisAlignment:

        CrossAxisAlignment.start,



        children:[




          Row(


            children:[



              const Icon(

                Icons.lightbulb,

                color:

                Colors.green,

                size:20,

              ),




              const SizedBox(width:8),




              Text(

                t(context,"ai_insights"),

                style:

                const TextStyle(

                  fontSize:15,

                  fontWeight:

                  FontWeight.bold,

                ),

              ),



            ],

          ),





          const SizedBox(height:8),




          Text(

            "${t(context,"insight1")}\n"
            "${t(context,"insight2")}\n"
            "${t(context,"insight3")}\n"
            "${t(context,"insight4")}",



            style:

            const TextStyle(

              fontSize:12,

              height:1.5,

            ),


          ),



        ],

      ),


    );


  }
  @override
Widget build(BuildContext context){
  final language =Provider.of<LanguageService>(context).language;


final cropResult =

result["crop_prediction"] ?? {};




final recommendedCrop =

cropResult["recommended_crop"]

??

"Not Generated";




final fertilizerResult =

result["fertilizer_recommendation"]

??

result["fertilizer_prediction"]

??

{};




final yieldResult =

result["yield_prediction"]

??

result["yield"]

??

{};




final predictions =

cropResult["top_predictions"]

??

[];







return Scaffold(



appBar:

AppBar(


title:

Text(

t(context,"ai_recommendation"),

style:

const TextStyle(

fontSize:18,

),

),


centerTitle:true,


),







body:



Center(



child:



ConstrainedBox(



constraints:

const BoxConstraints(

maxWidth:700,

),





child:



SingleChildScrollView(



padding:

const EdgeInsets.all(12),





child:



Column(



children:[






Container(



width:

double.infinity,





padding:

const EdgeInsets.all(12),





decoration:

BoxDecoration(



gradient:

const LinearGradient(



colors:[



Colors.green,

Colors.lightGreen,



],



),




borderRadius:

BorderRadius.circular(16),



),





child:



Row(



mainAxisAlignment:

MainAxisAlignment.center,





children:[





const Icon(



Icons.smart_toy,



size:35,



color:Colors.white,



),





const SizedBox(width:10),





Text(



t(context,"analysis_completed"),



style:



const TextStyle(



color:Colors.white,



fontSize:17,



fontWeight:

FontWeight.bold,



),



),



],



),



),








const SizedBox(height:12),









Container(



width:

double.infinity,





padding:

const EdgeInsets.all(10),





decoration:

BoxDecoration(



color:

Colors.green.shade50,





borderRadius:

BorderRadius.circular(15),





border:

Border.all(

color:

Colors.green,

),



),






child:



Row(



mainAxisAlignment:

MainAxisAlignment.center,





children:[





Text(



getCropEmoji(

recommendedCrop.toString()

),



style:



const TextStyle(



fontSize:28,



),



),





const SizedBox(width:10),





Flexible(



child:



Text(



"${t(context,"recommended")}: ${CropTranslationService.translateCrop(
  recommendedCrop.toString(),
  language
)}",




style:



const TextStyle(



fontSize:18,



fontWeight:

FontWeight.bold,



color:

Colors.green,



),



),



),



],



),



),





const SizedBox(height:12),






GridView.count(


shrinkWrap:true,


physics:

const NeverScrollableScrollPhysics(),




crossAxisCount:2,



crossAxisSpacing:8,



mainAxisSpacing:8,



childAspectRatio:2.1,




children:[




buildSmallCard(


icon:Icons.eco,


title:t(context,"crop"),


value: CropTranslationService.translateCrop(
  selectedCrop,
  language
),

color:Colors.green,


),






buildSmallCard(


icon:Icons.bar_chart,


title:t(context,"yield"),


value:


yieldResult.isEmpty


?


t(context,"not_predicted")


:


"${yieldResult["predicted_yield_tons_per_hectare"] ??

yieldResult["yield"]} Tons",




color:Colors.blue,



),






buildSmallCard(


icon:Icons.cloud,


title:t(context,"weather"),


value:


"$temperature°C\n$humidity%",




color:Colors.cyan,



),






buildSmallCard(


icon:Icons.water_drop,


title:t(context,"rainfall"),


value:


"$rainfall mm",




color:Colors.teal,



),




],


),
                const SizedBox(height:12),






                // FERTILIZER

                buildFertilizerCard(

                  fertilizerResult,

                  context,

                ),






                const SizedBox(height:12),






                // AI INSIGHTS

                buildInsightsCard(

                  context,

                ),






                const SizedBox(height:15),






                Align(

                  alignment:

                  Alignment.centerLeft,



                  child:

                  Text(



                    t(context,"ai_confidence"),



                    style:



                    const TextStyle(



                      fontSize:16,



                      fontWeight:

                      FontWeight.bold,



                    ),



                  ),



                ),






                const SizedBox(height:8),







                ...predictions.map<Widget>((prediction){



                  double confidence =



                  prediction["confidence"] * 100;






                  return Card(



                    margin:

                    const EdgeInsets.only(

                      bottom:5,

                    ),




                    child:



                    Padding(



                      padding:

                      const EdgeInsets.all(8),





                      child:



                      Row(



                        mainAxisAlignment:

                        MainAxisAlignment.spaceBetween,





                        children:[






                          Text(



                            CropTranslationService.translateCrop(
  prediction["crop"].toString(),
  language
),




                            style:



                            const TextStyle(



                              fontSize:12,



                              fontWeight:

                              FontWeight.bold,



                            ),



                          ),







                          Text(



                            "${confidence.toStringAsFixed(1)}%",





                            style:



                            const TextStyle(



                              fontSize:12,



                              color:

                              Colors.green,



                              fontWeight:

                              FontWeight.bold,



                            ),



                          ),






                        ],



                      ),



                    ),



                  );



                }).toList(),







                const SizedBox(height:12),







                SizedBox(



                  width:

                  double.infinity,





                  child:



                  ElevatedButton(



                    onPressed:(){





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



                    Text(



                      t(context,"back_dashboard"),



                    ),




                  ),



                ),




              ],



            ),



          ),



        ),



      ),



    );



  }



}