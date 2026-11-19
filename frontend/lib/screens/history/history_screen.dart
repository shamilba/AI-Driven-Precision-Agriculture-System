import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/api_service.dart';
import '../../services/user_session.dart';

import '../../localization/app_localizations.dart';
import '../../services/language_service.dart';
import '../../services/crop_translation_service.dart';

class HistoryScreen extends StatefulWidget {

  const HistoryScreen({super.key});


  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();

}



class _HistoryScreenState extends State<HistoryScreen>{

  String t(BuildContext context,String key){

  final language =
  Provider.of<LanguageService>(context)
      .language;


  return AppLocalizations.translate(
    key,
    language,
  );

}


  List<dynamic> history = [];

  bool loading = true;



  @override
  void initState(){

    super.initState();

    loadHistory();

  }




  Future<void> loadHistory() async {


    if(UserSession.userId == null){


      setState((){

        loading = false;

      });


      return;

    }



    try{


      final data =
      await ApiService.getHistory(

        UserSession.userId!,

      );



      setState((){


        history = data;

        loading = false;


      });



    }


    catch(e){



      setState((){


        loading = false;


      });

if(!mounted) return;

      ScaffoldMessenger.of(context)
      .showSnackBar(


        const SnackBar(

          content:

          Text(
            "Failed to load history"
          ),

        ),


      );


    }


  }





  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar: AppBar(

        title:

Text(
  t(context,"previous_analysis")
),

      ),




      body:



      loading


      ?


      const Center(

        child:

        CircularProgressIndicator(),

      )



      :



      history.isEmpty



      ?



      Center(

  child:

  Text(

    t(context,"no_analysis"),

    style:

    const TextStyle(

      fontSize:18,

    ),

  ),

)



      :



      ListView.builder(


        padding:

        const EdgeInsets.all(16),



        itemCount:

        history.length,



        itemBuilder:(context,index){



          final item = history[index];

final language =
Provider.of<LanguageService>(context)
    .language;

          return Card(


            elevation:4,


            margin:

            const EdgeInsets.only(

              bottom:15,

            ),



            shape:

            RoundedRectangleBorder(

              borderRadius:

              BorderRadius.circular(15),

            ),



            child:

            Padding(


              padding:

              const EdgeInsets.all(16),



              child:

              Column(


                crossAxisAlignment:

                CrossAxisAlignment.start,



                children:[



                  Text(


                    "${t(context,"crop")}: ${CropTranslationService.translateCrop(
  item["selected_crop"].toString(),
  language
)}",



                    style:

                    const TextStyle(


                      fontSize:18,


                      fontWeight:

                      FontWeight.bold,


                    ),


                  ),




                  const SizedBox(height:10),




                  Text(

                    "${t(context,"ai_suggested_crop")}: ${CropTranslationService.translateCrop(
  item["recommended_crop"].toString(),
  language
)}",

                  ),




                  Text(

                    "${t(context,"fertilizer")}: ${item["fertilizer"]}",

                  ),




                  Text(

                    "${t(context,"expected_yield")}: ${item["yield_prediction"]} Tons/Ha",

                  ),




                  Text(

                    "${t(context,"temperature")}: ${item["temperature"]} °C",

                  ),




                  Text(

                    "${t(context,"humidity")}: ${item["humidity"]} %",

                  ),




                  Text(

                    "${t(context,"rainfall")}: ${item["rainfall"]} mm",

                  ),



                ],


              ),


            ),


          );


        },


      ),



    );


  }


}